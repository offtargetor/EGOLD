use strict;
open IN,$ARGV[0];#fa
open IN2,$ARGV[1];#out
my (%sg,$name,$seq,@A,$f,$miss,%hash,$aa,$bb,$cc,$dd,$ee,$key,%pos);
my $len=$ARGV[2];
print "pos\tseq\tall\tcalled\ttype\tm1\tm2\tm3\tm4\tmg5";
for(my $i=1;$i<=$len;$i++){
	print "\tp$i";
}
print "\n";
while(<IN>){
	chomp;
	if(/>(.*)/){
		$name=$1;
	}
	else{
		$sg{$name}.=$_;
	}
}
while(<IN2>){
	chomp;
	$f=$_;
	@A=split/\s+/,$f;
	%hash=();
	my $tn=$A[0];
	$tn=~s/.bed//;
	$seq=uc($sg{$tn});
	%pos=();
	open IN3,"results/$A[0].fa.tongji";
	while(<IN3>){
		chomp;
		my @B=split/\s+/,$_;
		$miss=0;
		for(my $i=0;$i<23;$i++){
			if(substr($seq,$i,1) ne substr($B[0],$i,1)){
				$miss++;
				$pos{$i}++;
			}
		}
		$hash{$miss}+=$B[1];
	}
	close IN3;
	$aa=0;$bb=0;$cc=0;$dd=0;$ee=0;
	foreach $key (keys %hash){
		if($key==1){$aa+=$hash{$key};}
		if($key==2){$bb+=$hash{$key};}
		if($key==3){$cc+=$hash{$key};}
		if($key==4){$dd+=$hash{$key};}
		if($key>=5){$ee+=$hash{$key};}
	}
	print "$tn\t$seq\t$A[1]\t$A[2]\t$A[3]\t$aa\t$bb\t$cc\t$dd\t$ee";
	for(my $i=0;$i<23;$i++){
		print "\t$pos{$i}";
	}
	print "\n";
}
close IN;

