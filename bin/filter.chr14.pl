use strict;
open IN,$ARGV[0];
my %hash;
my $name;
while(<IN>){
	chomp;
	if(/>.*(chr\w+).*/){
		$name=$1;
	}
	else{
		my $a=uc($_);
		$hash{$a}{$name}++;
	}
}
close IN;
foreach my $key (keys %hash){
	foreach my $key2 (keys %{$hash{$key}}){
		if($hash{$key}{$key2} >=14){
			print "$key\n";
		}
	}
}

