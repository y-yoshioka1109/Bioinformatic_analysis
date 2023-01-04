$n_args = @ARGV;
if (($n_args != 2)) {
    die "\n Usage: perl make_AnnotationFile_scaffold.pl   <scaffold name>  <AGP file>\n\n";
}
   print  "COMMON\tSUBMITTER\t\tab_name\tYoshioka,Y.\n",
	     "\t\t\tab_name\tLast-name,First-name.\n",
             "\t\t\tcontact\tFirst-name Last-name\n",
             "\t\t\temail\temail\@gmail\n",
             "\t\t\tphone\t81-#-####-####\n",
             "\t\t\tfax\t81-#-####-####\n",
             "\t\t\tinstitute\tAtmosphere and Ocean Research Institute, The University of Tokyo\n",
             "\t\t\tdepartment\tMolecular Marine Biology\n",
             "\t\t\tcountry\tJapan\n",
             "\t\t\tstate\tChiba\n",
             "\t\t\tcity\tKashiwa\n",
             "\t\t\tstreet\t5-1-5 Kashiwanoha\n",
             "\t\t\tzip\t277-8564\n",
             "\tREFERENCE\t\ttitle\tGenome of ####.\n",
             "\t\t\tab_name\tYoshioka,Y.\n",
             "\t\t\tyear\t2022\n",
             "\t\t\tstatus\tunpublished\n",
             "\tDATE\t\thold_date\t20260701\n",
             "\tST_COMMENT\t\ttagset_id\tGenome-Assembly-Data\n",
             "\t\t\tAssembly Method\tHifiasm v. 0.14; Purge_haplotigs v. 1.1.1; HaploMerger v. 2; LINKS v.1.8.7; Hypo v. 1.0.3\n",
             "\t\t\tAssembly Name\t####_1.0\n",
             "\t\t\tGenome Coverage\t33.7X; 205X\n",
             "\t\t\tSequencing Technology\tPacBio Sequel (HiFi); Illumina HiSeq\n",
             "\tDBLINK\t\tproject\tPRJDB#####\n",
             "\t\t\tbiosample\tSAMD00#####\n";

         print  "\t\t\tsequence read archive\tDRR######\n";
	       print  "\t\t\tsequence read archive\tDRR######\n";

         print     "\tDATATYPE\t\ttype\tWGS\n",
                   "\tKEYWORD\t\tkeyword\tWGS\n",
                   "\t\t\tkeyword\tSTANDARD_DRAFT\n", ;
open(SCA,$ARGV[0]);
while($l=<SCA>){
   chomp $l;
   #$lがscaffold名
   print  "$l\tsource\t1\.\.E\torganism\t#### ####\n",
          "\t\t\tmol_type\tgenomic DNA\n\t\t\tcountry\tJapan:Okinawa, ####\n",
          "\t\t\tff_definition\t@@[organism]@@ DNA, @@[submitter_seqid]@@\n",
      	  "\t\t\tsubmitter_seqid\t@@[entry]@@\n",
	        "\t\t\tcollection_date\t2018-08-07\n";

   #read AGP file
   open(AGP, $ARGV[1]);
   while($line=<AGP>){
      @a=split(/\t/,$line);
      if($l eq $a[0] and $a[4] ne "W"){
             print "\tassembly_gap\t$a[1]..$a[2]\testimated_length\tknown\n",
                 "\t\t\tgap_type\twithin scaffold\n",
                 "\t\t\tlinkage_evidence\tstrobe\n";
      }  
   }

}


#シングルNをN*10にした場合はこちらを使う.
#open(SCA,$ARGV[0]);
#while($l=<SCA>){
#   chomp $l;
#   # $lがscaffold名
#   print  "$l\tsource\t1\.\.E\torganism\tPorites australiensis\n",
#          "\t\t\tmol_type\tgenomic DNA\n\t\t\tcountry\tJapan:Okinawa, Sesoko Island\n",
#          "\t\t\tff_definition\t@@[organism]@@ DNA, @@[submitter_seqid]@@\n",
#	  "\t\t\tsubmitter_seqid\t@@[entry]@@\n",
#	  "\t\t\tcollection_date\t2012\n";
#
#  #read AGP file
#   open(AGP, $ARGV[1]);
#   while($line=<AGP>){
#      @a=split(/\t/,$line);
#      if($l eq $a[0] and $a[4] ne "W"){
#         if($a[5] == 10){## gap長が1bpの場合
#             print "\tassembly_gap\t$a[1]..$a[2]\testimated_length\tunknown\n",
#                   "\t\t\tgap_type\twithin scaffold\n",
#                  "\t\t\tlinkage_evidence\tpaired-ends\n";
#         }
#         else{
#             print "\tassembly_gap\t$a[1]..$a[2]\testimated_length\tknown\n",
#                 "\t\t\tgap_type\twithin scaffold\n",
#                 "\t\t\tlinkage_evidence\tpaired-ends\n";
#        }
#      }
#   }
#}
