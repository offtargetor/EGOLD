#/usr/bin/bash
### Author: Hu Feng
while getopts ":r:g:f:e:m:b:t:h" opt; do
	case $opt in
		r) refpath=$OPTARG ;;
		g) sgRNA=$OPTARG ;;
		f) feature=$OPTARG ;;
		e) editor=$OPTARG ;;
		m) models=$OPTARG ;;
		b) binpath=$OPTARG ;;
		t) threads=$OPTARG ;;
		h) echo "Usage: $0 -r <refpath> -g <sgRNA> -f <featurepath> -e <editor:Cas9/RYCas9/SuperFiCas9/eCas9/HypaCas9/HiFiCas9/Sniper2LCas9/OptiCas9/TadA-8e-Cas9/TadA-8e-RYCas9/TadA-8e-SuperFiCas9/rApobec1-Cas9/rApobec1-RYCas9/rApobec1-SuperFiCas9/YE1-Cas9/YE1-RYCas9/YE1-SuperFiCas9> -m <modelspath> -b <binpath> -t <threads>\n-r	The absolute path of reference.\n-g	sgRNA.fa.\n-b	The path of script.\n-t	The number of threads."; exit ;;
		?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
	esac
done
# Check if all required arguments are provided
if [ -z $refpath ] || [ -z $sgRNA] || [ -z $feature] || [ -z $editor] || [ -z $models] || [ -z $binpath ] || [ -z $threads ]; then
	echo "Missing required arguments."
	exit 1
fi
ref=`echo $refpath|awk -F"/" '{print $NF}'`
$binpath/finder.mismatch $refpath $sgRNA  9 $sgRNA.all.position $threads
/mnt/ZuoStorage3/fenghu/soft/miniconda3/bin/perl $binpath/mismatch.pl $sgRNA.all.position >$sgRNA.all.position.mismatch
less $sgRNA.all.position.mismatch|awk '{print $1"\t"$2"\t"$3}' >$sgRNA.off
less $sgRNA.all.position.mismatch|awk '{print $2"\t"$3}' |sort -u >$sgRNA.target.sortu
/mnt/ZuoStorage3/fenghu/soft/miniconda3/bin/perl $binpath/deal.mismatch2ai.pl $sgRNA.target.sortu $sgRNA.target.sortu.ai

mkdir tempp
cd tempp
nohup perl $binpath/add.epigenetics.l50.pl  $feature/hg38.ATAC.bed $feature/hg38.methylation.bed $feature/hg38.293t.fpkm.pos ../$sgRNA.off >$sgRNA.off.add2 &
cat ../feature/list.histone|while read line
do
	a=`echo $line|awk '{print $1}'`
	b=`echo $line|awk '{print $2}'`
	perl $binpath/add2.epigenetics.l50.pl  $feature/$b.bedgraph ../$sgRNA.off >$a.$sgRNA.off.add
done
paste dnase.$sgRNA.off.add elk4.$sgRNA.off.add h3k27ac.$sgRNA.off.add h3k36me3.$sgRNA.off.add h3k4me1.$sgRNA.off.add h3k9me3.$sgRNA.off.add rnap.$sgRNA.off.add tcf7l2.$sgRNA.off.add trim28.$sgRNA.off.add znf274.$sgRNA.off.add |awk '{printf $1"\t"$2"\t"$3;for(i=4;i<=NF;i=i+4){printf "\t"$i}printf "\n"}' >$sgRNA.off.add.histone.l50
perl $binpath/add.epigenetics.l50.pl  $feature/hg38.ATAC.bed $feature/hg38.methylation.bed $feature/hg38.293t.fpkm.pos ../$sgRNA.off >$sgRNA.off.add2
cd ../
less $sgRNA.target.sortu.ai |awk '{a=$2;b=$1;$1=a;$2=b;for(i=1;i<NF;i++){printf $i"\t"}print $NF}' >$sgRNA.target.sortu.ai2
nohup perl $binpath/combine.epigenetics-histone.pl tempp/$sgRNA.off.add2 tempp/$sgRNA.off.add.histone.l50 $sgRNA.target.sortu.ai2 $sgRNA.off >$sgRNA.off.mismatch.epigenetics &
conda activate py38
python $binpath/sgoff-label-pos-predict.py $models/$editor.indel.snv.mismatch2.l50_best_model.joblib $sgRNA.off.mismatch.epigenetics $editor-$sgRNA.predict
conda deactivate




