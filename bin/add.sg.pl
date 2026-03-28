use strict;
open IN,$ARGV[0];
open IN2,$ARGV[1];
my %hash;
while(<IN>){
	chomp;
	my @A=split/\s+/,$_;
	$hash{$A[0]}=$A[1];
}
while(<IN2>){
	chomp;
	my @A=split/\s+/,$_,2;
	print "$A[0]\t$hash{$A[0]}\t$A[1]\n";
}
close IN;
close IN2;
