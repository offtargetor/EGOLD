use strict;
open IN,$ARGV[0];
my ($name,$mis,$i,@A,@B,$n,$seq);
while(<IN>){
	chomp;
	my @A=split/\s+/,$_;
	$A[3]=~s/\,//;$A[1]=~s/\,//;$A[7]=~s/\,//;
	my $end=$A[3]+22;
	$name=$A[1].":".$A[3]."-".$end."\(".$A[7]."\)";
	$mis="Miss";
	$n=0;
	$A[9]=~s/\,//;
	my $target=uc($A[9]);
	$seq=uc($A[11]);
	@A=split//,$target;
	@B=split//,$seq;
	for($i=0;$i<@A;$i++){
		if($A[$i] ne $B[$i]){
			my $pos=$i+1;
			$mis.="-".$pos;
			$n++;
		}
	}
	print "$name\t$target\t$seq\t$n\t$mis\n";
}
close IN;
