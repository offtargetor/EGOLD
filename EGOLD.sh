#/usr/bin/bash
### Author: Hu Feng
while getopts ":r:p:l:s:e:b:m:w:t:h" opt; do
	case $opt in
		r) refpath=$OPTARG ;;
		p) pampath=$OPTARG ;;
		l) sglen=$OPTARG ;;
		s) side=$OPTARG ;;
		e) ecpospath=$OPTARG ;;
		b) binpath=$OPTARG ;;
		m) acstart=$OPTARG ;;
		w) window=$OPTARG ;;
		t) threads=$OPTARG ;;
		h) echo "Usage: $0 -r <refpath> -p <pampath> -l <sglen> -s <side> -e <ecpospath> -b <binpath> -m <acstart> -t <threads>\n-r	The absolute path of reference.\n-p	The absolute path of pam.\n-l	The length of sgRNA.\n-s	The side of PAM.\n-e	The position of essential and cell-cycle gene(bed file).\n-b	The path of script.\n-m	The start position of AC or CA for base editor.\n-w	The length of editing windows\n-t	The number of threads."; exit ;;
		?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
	esac
done
# Check if all required arguments are provided
if [ -z $refpath ] || [ -z $pampath ] || [ -z $sglen ] || [ -z $side ] || [ -z $ecpospath ] || [ -z $binpath ] || [ -z $acstart ] || [ -z $window ] || [ -z $threads ]; then
	echo "Missing required arguments."
	exit 1
fi
ref=`echo $refpath|awk -F"/" '{print $NF}'`
pam=`echo $pampath|awk -F"/" '{print $NF}'`
perl $binpath/1.split.pam.pl $refpath $sglen $pam $side $ref.sg-$pam $ref.sg-$pam.mask
echo "Succeslly split"
bwa aln -t 20 $refpath $ref.sg-$pam >$ref.sg-$pam.sai
bwa samse -f $ref.sg-$pam.sam $refpath $ref.sg-$pam.sai $ref.sg-$pam
perl  $binpath/filter.chr14.pl $ref.sg-$pam >$ref.sg-$pam.ge14
perl  $binpath/filter.chr14.sg.pl $ref.sg-$pam.ge14 $ref.sg-$pam >$ref.sg-$pam.fge14
perl $binpath/filter.repeat.pl $ref.sg-$pam.mask $ref.sg-$pam.fge14 >$ref.sg-$pam.fge14.fm
perl $binpath/tiqu-number.pl $ref.sg-$pam.fge14.fm $ref.sg-$pam.sam  >$ref.sg-$pam.sam.fge14.fm
perl $binpath/7.filter.pos.pl $ecpospath $ref.sg-$pam.sam.fge14.fm >$ref.sg-$pam.sam.fge14.fm.flc
perl $binpath/test.direction.pl $ref.sg-$pam.sam.fge14.fm.flc $ref.sg-$pam >$ref.sg-$pam.sam.fge14.fm.flc.direction
less $ref.sg-$pam.sam.fge14.fm.flc.direction |grep -vE "chrUn|GCGCGCGC|GAGAGAGA|GGGG|GTGTGTGT|ACACACAC|AAAA|TTTT|CCCC|ATATATAT|AGAGAGAG|CACACACA|CGCGCGCG|CTCTCTCT|TATATATA|TCTCTCTC|TGTGTGTG|AGGAGGAGG|ACCACCACC|ATTATTATT|CAACAACAA|CTTCTTCTT|CGGCGGCGG|TAATAATAA|TCCTCCTCC|TGGTGGTGG|GAAGAAGAA|GTTGTTGTT|GCCGCCGCC" |awk -v pos=$acstart -v win=$window '{a=substr($2,pos,win);if(a=="AC" || a=="CA")print $0}' >$ref.sg-$pam.sam.fge14.fm.flc.fd
less $ref.sg-$pam.sam.fge14.fm.flc.fd|awk '{print ">"$1"\n"$2}' >$ref.sg-$pam.sam.fge14.fm.flc.fd.fa
blastn -task blastn-short -db $refpath -query $ref.sg-$pam.sam.fge14.fm.flc.fd.fa  -outfmt 7 -out $ref.sg-$pam.sam.fge14.fm.flc.fd.fa.out -word_size 7  -num_threads $threads -max_target_seqs 10000
mkdir results
perl $binpath/print.pos.pl $ref.sg-$pam.sam.fge14.fm.flc.fd.fa.out >results/$ref.sg-$pam.sam.fge14.fm.flc.fd.fa.pos
cd results
less $ref.sg-$pam.sam.fge14.fm.flc.fd.fa.pos|awk '{if(a!=$5){print a"\t"i;a=$5;i=1}else{i++}}END{print a"\t"i}' |awk '{if($2<5000)print $1}' >l5000.list
perl $binpath/print.bed.pl l5000.list $ref.sg-$pam.sam.fge14.fm.flc.fd.fa.pos
ls *bed|grep -v "list.bed" >list.bed
n=`less list.bed|wc -l`
splitnum=`echo $n|awk -v a=$n -v t=$threads '{c=int(a/t)+1;print c}'`
rm bb*
split -l $splitnum list.bed bb
rm *num
ls bb*|grep -v "\."|while read line
do

	echo "cat $line|while read line" >$line.tongji.sh
	echo "do" >>$line.tongji.sh
	echo "bedtools getfasta -fi $refpath -bed \$line -s >\$line.fa" >>$line.tongji.sh
	echo "less \$line.fa |grep -v \">\"|sort |awk '{\$1=toupper(\$1);if(a!=\$1){print a\"\\\t\"i;a=\$1;i=1}else{i++}}END{print a\"\\\t\"i}' >\$line.fa.tongji" >>$line.tongji.sh
	echo "less \$line|awk '{a=\$2-20;b=\$3+20;print \$1\"\\\t\"a\"\\\t\"b\"\\\t\"\$4\"\\\t\"\$5}' >\$line.extend" >>$line.tongji.sh
	echo "bedtools getfasta -fi $refpath -bed \$line.extend -s >\$line.extend.fa" >>$line.tongji.sh
	echo "bwa mem $refpath \$line.extend.fa  >\$line.extend.fa.sam" >>$line.tongji.sh
	echo "perl $binpath/tongji-filter-sam.pl \$line.extend.fa.sam >\$line.extend.fa.sam.filter" >>$line.tongji.sh
	echo "a=\`less \$line|wc -l\`" >>$line.tongji.sh
	echo "b=\`less \$line.extend.fa.sam.filter|wc -l\`" >>$line.tongji.sh
	echo "c=\`less \$line.fa.tongji|wc -l\`" >>$line.tongji.sh
	echo "echo \"\$line     \$a     \$b     \$c\" >>$line.num" >>$line.tongji.sh
	echo "done" >>$line.tongji.sh
	nohup sh $line.tongji.sh &
done
