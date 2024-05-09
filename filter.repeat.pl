use strict;
open IN,$ARGV[0];#mask
open IN2,$ARGV[1];#fg14
my %hash;
my $name;
while(<IN>){
	chomp;
	if(/>(.*)/){
		$name=$1;
	}
	else{
		my $A=$_=~s/[A-Z]//g;
		if($A>=1){
			$hash{$name}=1;
		}
	}
}
close IN;
while(<IN2>){
	chomp;
	if(/>(.*)/){
                $name=$1;
        }
	else{
		if(exists $hash{$name}){
			print ">$name\n$_\n";
		}
	}
}
close IN;
close IN2;	
