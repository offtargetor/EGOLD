use strict;
open IN,$ARGV[0];
my $flag;
while(<IN>){
	chomp;
	my $a=$_;
	$flag=0;
	open IN2,"<$a.fa.tongji";
	while(<IN2>){
		my @A=split/\s+/,$_,2;
		if($A[1]>30){
			$flag=1;
		}
	}
	close IN2;
	if($flag==0){
		print "$a\n";
	}
}
close IN;
