# for prepare DDBJ format fasta
# example;
# >scaf1
# ggacaggctgccgcaggagccagg 
# ggacaggctgccgcaggagccagg

# >scaf1 
# ggacaggctgccgcaggagccaggggacaggctgccgcaggagccagg
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
