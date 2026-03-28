use strict;
use warnings;
use Bio::Seq;
use Bio::Tools::dpAlign;
use Bio::AlignIO;
open IN,$ARGV[0];
open OUT,">$ARGV[1]";
my ($i,$total,@P,$ma,$mb,$mc,$md,$me,$mf,$mpam,$paa,$pat,$pac,$pag,$pba,$pbt,$pbc,$pbg,$pca,$pct,$pcc,$pcg,$gc,$pbcaa,$pbcat,$pbcac,$pbcag,$pbcta,$pbctt,$pbctc,$pbctg,$pbcca,$pbcct,$pbccc,$pbccg,$pbcga,$pbcgt,$pbcgc,$pbcgg);
print OUT "target\tsgRNA\tp1\tp2\tp3\tp4\tp5\tp6\tp7\tp8\tp9\tp10\tp11\tp12\tp13\tp14\tp15\tp16\tp17\tp18\tp19\tp20\tp21\tp22\tp23\ttotal\tma\tmb\tmc\tmd\tme\tmf\tmpam\tpaa\tpat\tpac\tpag\tpba\tpbt\tpbc\tpbg\tpca\tpct\tpcc\tpcg\tgc\tpbcaa\tpbcat\tpbcac\tpbcag\tpbcta\tpbctt\tpbctc\tpbctg\tpbcca\tpbcct\tpbccc\tpbccg\tpbcga\tpbcgt\tpbcgc\tpbcgg\tidentity\tscore\n";
while(<IN>){
	chomp;
	$i=0;$total=0;@P=();$ma=0,$mb=0,$mc=0,$md=0,$me=0;$mf=0;$mpam=0,$gc=0;
	my @A=split/\s+/,$_;
	my @B=split//,$A[0];
	my @C=split//,$A[1];
	foreach($i;$i<@B;$i++){
		if($B[$i] ne $C[$i]){
			$total++;
			$P[$i]=1;
			if($i<5){$ma++;$me++;}elsif($i<10){$mb++;$me++;}elsif($i<15){$mc++;$mf++;}elsif($i<20){$md++;$mf++;}else{$mpam++;}
		}
		else{
			$P[$i]=0;
		}
	}
	if($C[20] eq "A"){$paa=1;$pat=0;$pac=0;$pag=0;}if($C[20] eq "T"){$paa=0;$pat=1;$pac=0;$pag=0;}if($C[20] eq "C"){$paa=0;$pat=0;$pac=1;$pag=0;}if($C[20] eq "G"){$paa=0;$pat=0;$pac=0;$pag=1;}
	if($C[21] eq "A"){$pba=1;$pbt=0;$pbc=0;$pbg=0;}if($C[21] eq "T"){$pba=0;$pbt=1;$pbc=0;$pbg=0;}if($C[21] eq "C"){$pba=0;$pbt=0;$pbc=1;$pbg=0;}if($C[21] eq "G"){$pba=0;$pbt=0;$pbc=0;$pbg=1;}
	if($C[22] eq "A"){$pca=1;$pct=0;$pcc=0;$pcg=0;}if($C[22] eq "T"){$pca=0;$pct=1;$pcc=0;$pcg=0;}if($C[22] eq "C"){$pca=0;$pct=0;$pcc=1;$pcg=0;}if($C[22] eq "G"){$pca=0;$pct=0;$pcc=0;$pcg=1;}
	my $seq=substr($A[1],21,2);
	if($seq eq "AA"){$pbcaa=1;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "AT"){$pbcaa=0;$pbcat=1;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "AC"){$pbcaa=0;$pbcat=0;$pbcac=1;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "AG"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=1;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "TA"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=1;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "TT"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=1;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "TC"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=1;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "TG"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=1;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "CA"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=1;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "CT"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=1;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "CC"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=1;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "CG"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=1;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "GA"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=1;$pbcgt=0;$pbcgc=0;$pbcgg=0;}
	if($seq eq "GT"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=1;$pbcgc=0;$pbcgg=0;}
	if($seq eq "GC"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=1;$pbcgg=0;}
	if($seq eq "GG"){$pbcaa=0;$pbcat=0;$pbcac=0;$pbcag=0;$pbcta=0;$pbctt=0;$pbctc=0;$pbctg=0;$pbcca=0;$pbcct=0;$pbccc=0;$pbccg=0;$pbcga=0;$pbcgt=0;$pbcgc=0;$pbcgg=1;}
	$seq=substr($A[1],0,20);
	my $countc=$seq=~tr/C/T/;
	my $countg=$seq=~tr/G/T/;
	$gc=($countc+$countg)/20;
	print OUT "$A[0]\t$A[1]";
	foreach(my $n=0;$n<@P;$n++){
		print OUT "\t$P[$n]";
	}
	my $sgRNA=substr($A[0],0,20);
	my $seq1 = Bio::Seq->new(-seq => $sgRNA, -alphabet => 'dna');
	my $seq2 = Bio::Seq->new(-seq => $A[1], -alphabet => 'dna');
	my $factory = Bio::Tools::dpAlign->new();
	my $alignment = $factory->pairwise_alignment($seq1, $seq2);
	my $identity = $alignment->percentage_identity;
	my $score = $alignment->score;
	print OUT "\t$total\t$ma\t$mb\t$mc\t$md\t$me\t$mf\t$mpam\t$paa\t$pat\t$pac\t$pag\t$pba\t$pbt\t$pbc\t$pbg\t$pca\t$pct\t$pcc\t$pcg\t$gc\t$pbcaa\t$pbcat\t$pbcac\t$pbcag\t$pbcta\t$pbctt\t$pbctc\t$pbctg\t$pbcca\t$pbcct\t$pbccc\t$pbccg\t$pbcga\t$pbcgt\t$pbcgc\t$pbcgg\t$identity\t$score\n";
}
close IN;

