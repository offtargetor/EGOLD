use strict;
open IN,$ARGV[0];#ATAC
open IN2,$ARGV[1];#methylation
open IN3,$ARGV[2];#RNA
open IN4,$ARGV[3];
my (%atac,%meth,%rna);
while(<IN>){
	chomp;
	my @A=split/\s+/,$_;
	$atac{$A[0]}{$A[1]}{$A[2]}=$A[3];
}
while(<IN2>){
	chomp;
	my @A=split/\s+/,$_;
	$meth{$A[0]}{$A[2]}=1;
}
while(<IN3>){
	chomp;
	my @A=split/\s+/,$_;
	$rna{$A[1]}{$A[2]."-".$A[3]}=$A[4];
}
my (@A,$chr,$st,$ed,$key,$me,$fr,$fa,$i,$ed);
while(<IN4>){
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
                next unless exists $atac{$chr}{$i};
		foreach $key (keys %{$atac{$chr}{$i}}){
			if(($st>=$key && $st<=$key+25) || ($ed<=$key+25 && $ed>=$key)){
				print "\t$atac{$chr}{$i}{$key}";
				$fa=1;
				last;
			}
		}
		last if $fa;
	}
	if($fa==0){print "\t0";}
	$me=0;
	for(my $i=$st;$i<=$ed;$i++){
		if(exists $meth{$chr}{$i}){
			$me++;
		}
	}
	print "\t$me";
	foreach $key (keys %{$rna{$chr}}){
		my @B=split/\-/,$key;
		if(($st>=$B[0] && $st<=$B[1]) || ($ed>$B[0] && $ed<=$B[1])){
			print "\t$rna{$chr}{$key}";
			$fr=1;
			last;
		}
		last if $fr;
		
	}
	if($fr==0){print "\t0";}
	print "\n";
}

close IN;
close IN2;
close IN3;
close IN4;


