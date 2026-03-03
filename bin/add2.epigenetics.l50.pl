use strict;
open IN,$ARGV[0];#ep
open IN2,$ARGV[1];
my (%hash);
while(<IN>){
	chomp;
	my @B=split/\s+/,$_;
	$hash{$B[0]}{$B[1]}{$B[2]}=$B[3];
}
close IN;
my (@A,$chr,$st,$ed,$key,$me,$fr,$fa,$fh,@B,@C,$i);
LAB:while(<IN2>){
	chomp;
	@A=split/\s+/,$_;
	if($A[0]=~/(.*)\:(\d+)\-(\d+).*+.*/){
		$fr=0;$fa=0;
		$chr=$1;$st=$2-15;$ed=$3+12;
	}
	elsif($A[0]=~/(.*)\:(\d+)\-(\d+).*-.*/){
		$fr=0;$fa=0;
		$chr=$1;$st=$2-12;$ed=$3+15;
	}
	print "$A[0]\t$A[1]\t$A[2]";
	for($i=$st-100;$i<=$ed;$i++){
		next unless exists $hash{$chr}{$i};
		foreach $key (keys %{$hash{$chr}{$i}}){
			if(($st>=$i && $st<=$key) || ($ed>=$i && $ed<=$key)){
				print "\t$hash{$chr}{$i}{$key}\n";
				$fr=1;
				last;
			}
		}
		last if $fr;
	}
	if($fr==0){print "\t0\n";}
}
close IN2;
