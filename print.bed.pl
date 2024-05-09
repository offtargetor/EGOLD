use strict;
open IN,$ARGV[0];
open IN2,$ARGV[1];
my ($flag,%hash,@A);
while(<IN>){
	chomp;
	$hash{$_}=1;
}
while(<IN2>){
	chomp;
	@A=split/\s+/,$_;
	if($flag ne $A[4] && !exists$hash{$A[4]}){
		close OUT;
		open OUT,">$A[4].bed";
		print OUT "$A[0]\t$A[1]\t$A[2]\t1\t1\t$A[3]\n";
		$flag=$A[4];
	}
	elsif(!exists$hash{$A[4]}){
		print OUT "$A[0]\t$A[1]\t$A[2]\t1\t1\t$A[3]\n";
	}
}
close IN;
close IN2;
close OUT;
