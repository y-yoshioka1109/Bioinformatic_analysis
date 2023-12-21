#Scaffold名をシンプルな名前に変更する (e.g. >s001)
 perl -ne 'if($_=~/^>/){@a=split(/_/,$_);print"$a[0]\n";}else{print$_;}' genome.fa > tmp

#Multi Fastaをscaffoldごとに分割.
 seqkit split -p 205 --out-dir scaffold genome.fa
 cd scaffold

#ATGCとNを分けてFasta形式で保存する. 後にContig/Gap長を記述する必要があるため.
 for i in `ls`;do perl ../contig-gap_producer.pl ${i} > ${i}.split ;done
 cat *split > cat_split.fa
 Ex. >s001                 >s001_contig
     AGATAGATNNNCGAT       AGATAGAT
                           >s001_gap
                           NNN
                           >s001_contig
                           CGAT

# *Optional* 1塩基のGapをN*10にする
 for i in `ls|grep .split`;do perl ../convertNto10N.pl ${i} > ${i}.2 ;done
 cat *.2 > cat_first.fa

# *Optional* ATGCとNに分割したFasta fileを１つにまとめる.
 for i in `ls|grep .split`;do perl ../convert_contig2scaffold.pl ${i} > ${i}3; done
 cat *.split3 > cat_second.fa

#元のファイルと分割したファイルの総塩基が一致することを確認する.
 cat *split |seqkit stat 

#s004, s005をテストとして, 配列長を抽出する. 1塩基のGapをN*10にした場合は下の行を実行する. 
 seqkit fx2tab -l cat_split.fa |awk -F"\t" '{print$1"\t"$4}' | grep -e "s004" -e "s005" > tmp.length
 seqkit fx2tab -l cat_second.fa |awk -F"\t" '{print$1"\t"$4}' | grep -e "s004" -e "s005" > tmp.length

#s004, s005をテストとして, 配列名を抽出する. 1塩基のGapをN*10にした場合は下の行を実行する. 
 grep ">"  cat_split.fa |perl -pe 's/>//g' |grep -e "s004" -e "s005" > tmp.name
 grep ">"  cat_second.fa |perl -pe 's/>//g' |grep -e "s004" -e "s005" > tmp.name

#s004, s005をテストとして, 配列名を抽出する. ついでにFastaの末尾に//を代入する.
 seqkit grep -nrp s004 -nrp s005 genome.fa | perl fasta_parsar.pl - > test.scaff

#AGPファイル (Contig/Gap長をまとめたファイル) を作成する.
 perl make_AGPfile2.pl tmp.length tmp.name > tmp.agp

#AGPファイルを元にアノテーションファイル (AGPに加え、著者/アッセンブリ作成方法/生データなどをまとめたファイル) を作成する. 1塩基のGapをN*10にした場合は下の行を実行する.
#アノテーションファイルの雛形はこちらを参照 (https://www.ddbj.nig.ac.jp/ddbj/file-format.html#sample)
 grep ">" cat_split.fa | grep -e "s004" -e "s005" |cut -b 2- |awk -F'_' '{print $1}' |uniq |perl ../make_AnnotationFile_scaffold.pl - tmp.agp > tmp.annotation
 grep ">" cat_first.fa | grep -e "s004" -e "s005" |cut -b 2- |awk -F'_' '{print $1}' |uniq |perl ../make_AnnotationFile_scaffold.pl - tmp.agp > tmp.annotation

# 以下のサブミッションサイトからfastaとannotationを提出する.
https://mss.ddbj.nig.ac.jp/home?locale=ja

#jPerserで確認する (32Gb memory required).
 jParser.sh -x tmp.annotation -s tmp.scaf 
 
