##########################################################################################
## for make another ver. of AGF file, using actual contig entry name
##########################################################################################

$n_args = @ARGV;
if (($n_args != 2)) {
  die "\n Usage: perl make_AGPfile.pl  <fasta length file> <accession num file> \n\n";
}

# put accession num into hash
open (ACC, $ARGV[1]);
while($l=<ACC>){
  chomp $l;
  @a = split(/\t/, $l);
  $name = $a[0];
  $id = $a[1];
  $ac{$name} = $name;
}
close ACC;

#parse fasta length file
open (LENGTH, $ARGV[0]);
while($line=<LENGTH>){
  chomp $line;
  @b= split(/\t/,$line);
  $target = $b[0];
  $leng = $b[1];
  $acnum = $ac{$target}; # get accession num for each
  @c= split(/\_/,$target); # for get scaffold name
  $sca = $c[0]; # get scaffold name from contig name
  if ($sca ne $prev){
    $start = 1;
    $count = 1;
    $end = $leng;
    print "$sca\t1\t",
          "$leng\t$count\tW\t",
          "$acnum\t1\t$end\t+\n";
    $count++;
    $start = $leng +1;
    $prev = $sca;
  }
  elsif($sca eq $prev){
     if ($target =~ m/contig/){
       $end = $start + $leng -1;
        print "$sca\t$start\t$end\t",
              "$count\tW\t$acnum\t",
              "1\t$leng\t+\n";
        $count++;
        $start = $end +1;
        $prev = $sca;
     }
    elsif ($target =~ m/gap/){
       $end = $start + $leng-1;
        print "$sca\t$start\t$end\t$count\t",
              "N\t$leng\trepeat",
              "\tyes\n";
        $count++;
        $start = $end +1;
        $prev = $sca;
     }

  }

}
