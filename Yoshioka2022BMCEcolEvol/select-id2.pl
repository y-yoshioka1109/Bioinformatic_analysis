open (LIST, $ARGV[0]);
while($l=<LIST>){
	chomp($l);
	@a=split(/\t/,$l);
	$c{$a[0]} = $l;
}
close LIST,

open (L, $ARGV[1]);
while($line=<L>){
	chomp($line);
	@b=split(/\t/,$line);
	if (exists($c{$line}) ){
		print "$c{$line}\n";
	}else{
		print "$line\t0\n";
	}
}
close(L);
