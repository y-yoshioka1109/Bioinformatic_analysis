# for prepare DDBJ format fasta
# example;
# >ENT_ANT0001|56|1p25||| 
# ggacaggctgccgcaggagccagg 
# 
# >ENT_ANT0002|56|1p25||| 
# ctcacacagatgctgcgcacaccgt 
# // 

while(<>){
  if($_ =~ /^>/){
     if(length ($seq) >1){
        print "$pid$seq\n//\n";
     }
     $pid = $_;
     $seq = '';
  }
  else{
     chomp;
     $seq = $seq . $_;
  }
}

if(length ($seq) >1){
      print "$pid$seq\n//\n";
   }
