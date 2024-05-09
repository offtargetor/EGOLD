use strict;
open IN,$ARGV[0];#fg14
open IN2,$ARGV[1];
my %hash;
while(<IN>){
	chomp;
	$hash{$_}=1;
}
my $name;
while(<IN2>){
	chomp;
	if(/>(.*)/){
		$name=$1;
	}
	else{
		if(!exists $hash{$_}){
			print ">$name\n$_\n";
		}
	}
}
close IN;
close IN2;
			
