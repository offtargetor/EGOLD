use strict;
open IN,$ARGV[0];
while(<IN>){
	chomp;
	my @A=split/\s+/,$_,2;
	if($A[1]!~/XA/ && $A[0]!~/\@/){
		print "$A[0]\n";
	}
}
close IN;
