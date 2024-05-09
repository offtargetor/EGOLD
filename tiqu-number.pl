use strict;
open IN,$ARGV[0];#fge14
open IN2,$ARGV[1];#sam
my @A;
my %hash;
while(<IN>){
	chomp;
	if(/>(.*)/){
		$hash{$1}=1;
	}
}
while(<IN2>){
	chomp;
	@A=split/\s+/,$_,12;
	if($A[11]=~/.*X0\:i\:(\d+).*X1\:i\:(\d+).*/){
		if($1+$2>=10 && exists $hash{$A[0]}){
			print "$A[0]\t$A[9]\t$1\t$2\n";
		}
	}
	elsif($A[11]=~/.*X0\:i\:(\d+).*/){
		if($1>=10 && exists $hash{$A[0]}){
                        print "$A[0]\t$A[9]\t$1\n";
                }
        }


}
close IN;
