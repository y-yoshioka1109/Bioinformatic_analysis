open (LIST, $ARGV[0]);
while($l=<LIST>){
	chomp($l);
	@a=split(/\t/,$l);
	$c{$a[0]} = 1;
}
close LIST,

open (L, $ARGV[1]);
while($line=<L>){
	chomp($line);
	@b=split(/\t/,$line);
	if (exists($c{$b[0]}) ){
		print "$line\n";
	}
}
close L,
