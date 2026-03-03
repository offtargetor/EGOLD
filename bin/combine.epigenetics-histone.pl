use strict;
open IN,$ARGV[0];#epegenetics
open IN2,$ARGV[1];#histone
open IN3,$ARGV[2];#63
open IN4,$ARGV[3];#off
my (%epe,%his,%mis,%target);
print "name	sgRNA	target	off	dnase	elk4	h3k27ac	h3k36me3	h3k4me1	h3k9me3	rnap	tcf7l2	trim28	znf274	atac	meth	fpkm	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	p11	p12	p13	p14	p15	p16	p17	p18	p19	p20	p21	p22	p23	total	ma	mb	mc	md	me	mf	mpam	paa	pat	pac	pag	pba	pbt	pbc	pbg	pca	pct	pcc	pcg	gc	pbcaa	pbcat	pbcac	pbcag	pbcta	pbctt	pbctc	pbctg	pbcca	pbcct	pbccc	pbccg	pbcga	pbcgt	pbcgc	pbcgg	identity	score\n";
while(<IN>){
	chomp;
	my @A=split/\s+/,$_,4;
	$epe{$A[0]}=$A[3];
}
while(<IN2>){
	chomp;
	my @A=split/\s+/,$_,4;
	$his{$A[0]}=$A[3];
}
while(<IN3>){
	chomp;
	my @A=split/\s+/,$_,3;
	$mis{$A[1]}=$A[2];
}
my (@A,$sg);
while(<IN4>){
	chomp;
	@A=split/\s+/,$_;
	if($A[5]>0){$A[5]=1;}else{$A[5]=0;}
	if(exists $epe{$A[0]}){
		print "$A[0]\t$A[2]\t$A[1]\t$A[5]\t$epe{$A[0]}\t$his{$A[0]}\t$mis{$A[1]}\n";
	}
}
close IN;
close IN2;
close IN3;
close IN4;
