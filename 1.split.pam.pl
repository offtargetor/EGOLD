#!/usr/bin/perl
use strict;
open IN,$ARGV[0];
my $sglen=$ARGV[1];
open IN2,$ARGV[2];
my $side=$ARGV[3];
open OUT,">./$ARGV[4]";
open OUT2,">./$ARGV[5]";
my ($name,$chr,$seq,%hash,%pam,$lenpam);
while(<IN>){
	chomp;
	if(/^>(.*)$/){
		my @A=split/\s+/,$1;
		$name=$A[0];
	}
	else{
		$hash{$name}.=$_;
	}
}
while(<IN2>){
	chomp;
	$pam{$_}=1;
	$lenpam=length($_);
}
my ($chr,$rechr,$i,$nseq,$pamseq,$sgseq);
foreach my $key (keys %hash){
	$chr=$hash{$key};
	my $len=length$chr;
	for($i=0;$i<$len-$sglen-$lenpam;$i=$i+1){
		$seq=substr($chr,$i,$sglen+$lenpam);
		$nseq=$seq;
		$seq=uc$seq;
		if($seq!~/N/){
			if($side==3){
				$sgseq=substr($seq,0,$sglen);
				$pamseq=substr($seq,$sglen,$lenpam);
			}
			elsif($side==5){
				$sgseq=substr($seq,$lenpam,$sglen);
				$pamseq=substr($seq,0,$lenpam);
			}
			my $countg=$sgseq=~tr/G/G/;
			my $countc=$sgseq=~tr/C/C/;
			if(($countg+$countc)/$sglen>=0.4 && ($countg+$countc)/$sglen<=0.8){
				foreach my $key2 (keys %pam){
					if($key2 eq $pamseq){
						my $end=$i+$sglen-1;
						print OUT ">$key\:$i\-$end\n$seq\n";
						print OUT2 ">$key\:$i\-$end\n$nseq\n";
						last;
					}
				}
			}
		}
	}
	for($i=$len;$i>$sglen+$lenpam;$i=$i-1){
                $seq=substr($chr,$i-$sglen-$lenpam,$sglen+$lenpam);
		$nseq=$seq;
		$seq=uc$seq;
                if($seq!~/N/){
			$seq=~tr/ATCG/TAGC/;
			$seq=reverse $seq;
                        if($side==3){
				$sgseq=substr($seq,0,$sglen);
				$pamseq=substr($seq,$sglen,$lenpam);
			}
			elsif($side==5){
				$sgseq=substr($seq,$lenpam,$sglen);
				$pamseq=substr($seq,0,$lenpam);
			}
                        my $countg=$sgseq=~tr/G/G/;
                        my $countc=$sgseq=~tr/C/C/;
                        if(($countg+$countc)/$sglen>=0.4 && ($countg+$countc)/$sglen<=0.8){
				foreach my $key2 (keys %pam){
					if($key2 eq $pamseq){
						my $start=$i-$sglen+1;
						print OUT ">re-$key\:$start\-$i\n$seq\n";
						print OUT2 ">re-$key\:$start\-$i\n$nseq\n";
						last;
					}
				}
			}
                }
        }

}
close IN;
close IN2;
close OUT;
close OUT2;
