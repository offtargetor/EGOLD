use strict;
open IN,$ARGV[0];#aaa
open IN2,$ARGV[1];#ngg
my %hash;
my $name;
while(<IN>){
	chomp;
	my @A=split/\s+/,$_;	
	$hash{$A[0]}=$A[1];
}
while(<IN2>){
	chomp;
	if(/>(.*)/){
                $name=$1;
        }
        else{
		if(exists $hash{$name}){
			my $seq=uc($_);
			print "$name\t$seq\n";
		}
        }
}
close IN;
close IN2;
