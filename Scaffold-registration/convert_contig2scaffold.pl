#This is for making scaffold from contig
#>sca1_contig1
 # AGCTC
 #>sca1_gap1
 # NNN
#-> 
 #>sca1
 # AGCTCNNN


while($_=<>){
        chomp;
        @a=split(/_/,$_);
        $name=$a[0];
        if($_=~/^>/){
                $sca=$name;
        }elsif($_!~/^>/){
                @b=split(//,$_);
                foreach $nuc (@b) {
                        $seq.=$nuc;
                }
        }
}
print"$sca\n";
print"$seq\n";
