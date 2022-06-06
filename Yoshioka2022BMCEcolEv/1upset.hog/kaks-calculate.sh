#!/bin/sh
#$ -S /bin/sh
#$ -cwd
#$ -N KAKS
#$ -pe def_slot 1
#$ -l s_vmem=8G
#$ -l mem_req=8G

export PATH=/lustre7/home/y-yoshioka/miniconda3/bin/:$PATH
source /home/y-yoshioka/.bashrc

for i in `head -n 1000 single-copy.lst`
#for i in N0.HOG0000546 N0.HOG0000548 N0.HOG0000549
do
 cd analysis
#alignment
 mafft --quiet --auto --thread 1 ../faa/${i}.lst.fa > ${i}.seq.fa.aligned

#alignment結果からcodonを取得
 ~/bin/pal2nal.v14/pal2nal.pl \
 ./${i}.seq.fa.aligned \
 ../fna/${i}.lst.fa \
 -nogap -nostderr \
 -output fasta > ${i}.pal2nal.fa

#KaKs_calculatorのinput形式に変換する。
 perl -e '$c=0;while(<>){chomp;if($_=~/^>/){print"\n";}else{print$_;}}print"\n";' ${i}.pal2nal.fa > tmp.in

#KaKsの算出
 KaKs_Calculator -i tmp.in -m MA -o temp  1>/dev/null
 echo -n ${i} >> kaks.MA.lst
 perl -ne '@a=split(/\t/,$_);shift(@a);foreach $l (@a){print"$l\n";}' temp |grep -v "^$"|perl -pe 's/\n/\t/g'|perl -pe 's/Model/Model\n/g' |perl -pe 's/\tMA/MA/g' |grep MA>>kaks.MA.lst

rm ${i}.seq.fa.aligned tmp.in ${i}.pal2nal.fa temp
done
