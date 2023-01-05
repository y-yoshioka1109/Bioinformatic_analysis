########################################################################
# Ortholoug clustering with seven genomes (adig, amil, aten, astr, mcac, meff, and paus)
########################################################################
 orthofinder -a 4 -f ./20210315

########################################################################
# Detection of Transposon-like genes
########################################################################
#Detection from Pfam keywords "Reverse transcriptase" and "Integrase"
 grep Pfam mcac.longest.aa.interpro.tsv |grep -e "Reverse transcriptase" -e "Integrase" |awk '{print$1}'|sort|uniq > transposon-like.pfam.ls

#Detection with Dfam database
 perl ~/bin/dfamscan.pl \
  -fastafile mcac.longest.mrna \
  -hmmfile ~/bin/RepeatMasker/Libraries/Dfam.hmm \
  -dfam_outfile mcac.longest.mrna.DfamHits.out \
  --cpu=2
 awk '{print$3}' mcac.longest.fa.DfamHits.out |grep mcac|sort|uniq > transposon-like.dfam.lst 

#Detection with TPSI
 ~/bin/TransposonPSI_08222010/transposonPSI.pl mcac.longest.mrna nuc
 awk '{print$5}' TPSI/mcac.longest.mrna.TPSI.allHits |sort|uniq > transposon-like.tpsi.lst

########################################################################
# Analysis for gene family compositions
########################################################################
#Move to Phylogenetic_Hierarchical_Orthogroups directory
#transposonを含むOGを検出
 for i in `cat transposon-like.all.lst`;do grep ${i} N0.tsv ;done |sort |uniq > transposon.hog.lst
#transposon-like OGを取り除いたリストを作成
 perl select-id_def2.pl transposon.hog.lst N0.tsv > N0.removing-transposon.tsv

#Gene counting for each species 
#adig
 grep adig N0.removing-transposon.tsv|perl -pe 's/.t/\n/g' |perl -pe 's/\t/\n/g'|grep -e adig -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > adig.GeneCounts.tsv
#aten
 grep aten N0.removing-transposon.tsv|perl -pe 's/\.t/\n/g' |perl -pe 's/\t/\n/g'|grep -e aten -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > aten.GeneCounts.tsv
#amil
 grep XP N0.removing-transposon.tsv|perl -pe 's/\.1/\n/g' |perl -pe 's/\t/\n/g'|grep -e XP -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > amil.GeneCounts.tsv
#astr
 grep astr N0.removing-transposon.tsv|perl -pe 's/\.t/\n/g' |perl -pe 's/\t/\n/g'|grep -e astr -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > astr.GeneCounts.tsv
#meff
 grep meff N0.removing-transposon.tsv|perl -pe 's/\.t/\n/g' |perl -pe 's/\t/\n/g'|grep -e meff -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > meff.GeneCounts.tsv
#mcac
 grep mcac N0.removing-transposon.tsv|perl -pe 's/\.t/\n/g' |perl -pe 's/\t/\n/g'|grep -e mcac -e HOG|perl -e '$c=0;$d=0;while($_=<>){chomp;if($d==1){if($_=~/HOG/){print"$pid\t$c\n";$c=0;$pid=$_}else{$c++}}else{$d=1;$pid=$_}}print"$pid\t$c\n"' > mcac.GeneCounts.tsv

#全部のOGリスト。binaryデータを作るため。
 cat adig.GeneCounts.tsv amil.GeneCounts.tsv aten.GeneCounts.tsv astr.GeneCounts.tsv meff.GeneCounts.tsv mcac.GeneCounts.tsv |awk '{print$1}'|sort |uniq > hog.lst
 perl select-id2.pl adig.GeneCounts.tsv hog.lst > adig.GeneCounts.all.lst
 perl select-id2.pl aten.GeneCounts.tsv hog.lst > aten.GeneCounts.all.lst
 perl select-id2.pl amil.GeneCounts.tsv hog.lst > amil.GeneCounts.all.lst
 perl select-id2.pl astr.GeneCounts.tsv hog.lst > astr.GeneCounts.all.lst
 perl select-id2.pl mcac.GeneCounts.tsv hog.lst > mcac.GeneCounts.all.lst
 perl select-id2.pl meff.GeneCounts.tsv hog.lst > meff.GeneCounts.all.lst
 paste adig.GeneCounts.all.lst aten.GeneCounts.all.lst amil.GeneCounts.all.lst astr.GeneCounts.all.lst mcac.GeneCounts.all.lst meff.GeneCounts.all.lst |awk -F"\t" '{print$1"\t"$2"\t"$4"\t"$6"\t"$8"\t"$10"\t"$12}' >  genecount.tsv


#Column components are below.
1	2	3	4	5	6	7
HOG	adig	aten	amil	astr	mcac	meff

#acropora
 awk -F"\t" '$2>0&&$3>0&&$4>0{print$1}' genecount.tsv > acropora.hog.lst
#astreopora
 awk -F"\t" '$5>0{print$1}' genecount.tsv > astreopora.hog.lst
#montipora
 awk -F"\t" '$6>0&&$7>0{print$1}' genecount.tsv > montipora.hog.lst
#まとめる
 cat acropora.hog.lst astreopora.hog.lst montipora.hog.lst |sort |uniq > hog.genus.lst
#binaryデータ
 perl select-id.pl acropora.hog.lst hog.genus.lst > acropora.hog.lst2
 perl select-id.pl astreopora.hog.lst hog.genus.lst > astreopora.hog.lst2
 perl select-id.pl montipora.hog.lst hog.genus.lst > montipora.hog.lst2
 paste acropora.hog.lst2 astreopora.hog.lst2 montipora.hog.lst2 |awk -F"\t" '{print$1"\t"$2"\t"$4"\t"$6"\t"$8}' > upset.lst

### UpSet ###
1upset.hog -> common in the three genus
2upset.hog -> montipora specific
3upset.hog -> common in mont and astr
4upset.hog -> astreopora specific
5upset.hog -> common in acro and mont
6upset.hog -> common in acro and astr
7upset.hog -> acropora specific

#上のフィルタリングではAcropora特異的なHOGにMontipora1種が持つHOGも含まれるため、そのようなHOGsを除去する。
 awk -F"\t" '$2==0&&$3==0&&$4==0&&$5==0{print$1}' genecount.tsv|perl select-id_def.pl - 2upset.hog.list |perl select-id4.pl - genecount.tsv > 2upset.hog.genecount.cleaned.tsv
 awk -F"\t" '$2==0&&$3==0&&$4==0{print$1}' genecount.tsv|perl select-id_def.pl - 3upset.hog.list |perl select-id4.pl - genecount.tsv > 3upset.hog.genecount.cleaned.tsv
 awk -F"\t" '$2==0&&$3==0&&$4==0&&$6==0&&$7==0{print$1}' genecount.tsv|perl select-id_def.pl - 4upset.hog.list | perl select-id4.pl - genecount.tsv > 4upset.hog.genecount.cleaned.tsv
 awk -F"\t" '$5==0{print$1}' genecount.tsv|perl select-id_def.pl - 5upset.hog.list | perl select-id4.pl - genecount.tsv > 5upset.hog.genecount.cleaned.tsv
 awk -F"\t" '$6==0&&$7==0{print$1}' genecount.tsv|perl select-id_def.pl - 6upset.hog.list | perl select-id4.pl - genecount.tsv > 6upset.hog.genecount.cleaned.tsv
 awk -F"\t" '$5==0&&$6==0&&$7==0{print$1}' genecount.tsv|perl select-id_def.pl - 7upset.hog.list | perl select-id4.pl - genecount.tsv > 7upset.hog.genecount.cleaned.tsv

#Upsetの結果をもとに、各領域に含まれるHOGを整理した。
#For montipora
 cat 1upset.hog/1upset.hog.genecount.tsv 2upset.hog/2upset.hog.genecount.cleaned.tsv 3upset.hog/3upset.hog.genecount.cleaned.tsv 5upset.hog/5upset.hog.genecount.tsv |awk '{print$1}' > montipora.hog.cleaned.lst
#For acropora
 cat 1upset.hog/1upset.hog.genecount.tsv 5upset.hog/5upset.hog.genecount.tsv 6upset.hog/6upset.hog.genecount.cleaned.tsv 7upset.hog/7upset.hog.genecount.cleaned.tsv |awk '{print$1}' > acropora.hog.cleaned.lst
#For astreopora
 cat 1upset.hog/1upset.hog.genecount.tsv 3upset.hog/3upset.hog.genecount.cleaned.tsv 4upset.hog/4upset.hog.genecount.cleaned.tsv 6upset.hog/6upset.hog.genecount.cleaned.tsv |awk '{print$1}' > astreopora.hog.cleaned.lst

 cat acropora.hog.cleaned.lst astreopora.hog.cleaned.lst montipora.hog.cleaned.lst|sort|uniq > hog.lst.cleaned

#Input file for Fig. 2.
montipora.hog.cleaned.lst; acropora.hog.cleaned.lst; astreopora.hog.cleaned.lst

########################################################################
# Analysis of transcriptome of early developmental stages
########################################################################
#After performing read mapping to reference sequences, collect genes with TPM > 1
 awk -F"\t" '$4>1{print$1}' larva1_salmon/quant.sf > larva1_above1TPM.lst

#Collect genes for which TPM > 1 in all samples
 perl select-id3.pl larva1_above1TPM.lst larva2_above1TPM.lst > common_larvae_above1TPM.lst

#Collect OG information
 for i in `cat common_larvae_above1TPM.lst`
 do
  grep ${i} N0.removing-transposon.tsv
 done |sort|uniq >  larvae.lst.og
