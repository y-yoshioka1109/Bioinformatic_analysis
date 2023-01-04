while($_=<>){
	chomp;
	$gap="NNNNNNNNNN\n";
	if($_ =~ /^>/){
		print "$_\n";
	}elsif($_ !~ /^>/){
		if($_=~/N/){
			if(length($_)<=1){
				print $gap;
			}else{
				print "$_\n";
			}
		}elsif($_ !~ /N/){
			print"$_\n";
		}
	}
}
