open (LIST, $ARGV[0]);
while($l=<LIST>){
	chomp($l);
	@a=split(/\t/,$l);
	$ID=$a[0];
	$c{$ID} = $l;
}
close LIST,

open (L, $ARGV[1]);
while($line=<L>){
	chomp($line);
	@b=split(/\t/,$line);
	if (exists($c{$b[0]}) ){
		print $c{$b[0]}."\t1\n";
	}else{
		print $line."\t0\n";
	}
}
close(L);
