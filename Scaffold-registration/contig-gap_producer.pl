#2019.10.19
#scaffoldを塩基配列とギャップに分けるスクリプト
 #Ex:AGATAGATNNNCGAT
 #1.AGATAGAT
 #2.NNN
 #3.CGAT
##

$count = 0;
$gapcount = 0;
$gapseq='';
$seq='';
while($_ = <>){
  if($_ =~ /^>/){
		chomp;
		$id=$_;
	}elsif($_ !~ /^>/){
		chomp;
		$_ =~ tr/a-z/A-Z/;
		@a = split (//, $_);
		foreach $nuc (@a){
			if ($nuc !~ /N/){
				if(length ($gapseq) >= 1){
					$gapcount++;
					print "$id\_gap$gapcount\n$gapseq\n";
					$gapseq = '';
					$seq .= $nuc;
				}else{
					$seq .= $nuc;
				}
			}elsif ($nuc =~ /N/){
				if(length ($seq) >= 1){
					$count++;
					print "$id\_contig$count\n$seq\n";
					$seq='';
					$gapseq .= $nuc;
				}else{
					$gapseq .= $nuc;
				}
			}
		}
	}
}
if(length ($gapseq) >= 1){
$gapcount++;
print "$id\_gap$gapcount\n$gapseq\n";
}elsif(length ($seq) >= 1){
$count++;
print "$id\_contig$count\n$seq\n";
}
