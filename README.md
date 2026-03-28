Here, we present the Endogenous Genome-wide Off-target Library Detection Sequencing (EGOLD) method for streamlined assessment of genome-wide off-target effects induced by genome editing tools. 

Need:
Bio::Tools::dpAlign;
python = 3.8.18.

Run：

(1): bash EGOLD.sh  -r <refpath> -p <pampath> -l <sglen> -s <side> -e <ecpospath> -b <binpath> -m <acstart> -t <threads>
-r	The absolute path of reference.
-p	The absolute path of pam.
-l	The length of sgRNA.
-s	The side of PAM.
-e	The position of essential and cell-cycle gene(bed file).
-b	The path of script.
-m	The start position of AC or CA for base editor.
-w	The length of editing windows.
-t	The number of threads.

(2): cat results/bb*.num |sed "~s/.bed//" >name.out

(3): perl bin/add.sg.pl name.out >name.out.sgRNA
