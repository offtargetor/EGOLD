#!/usr/bin/perl
use strict;
open IN,$ARGV[0];#filter-pos
open IN2,$ARGV[1];#5-results
my %pos;
while(<IN>){
	chomp;
	my @A=split/\t/,$_;
	$pos{$A[0]}{$A[1]}=$A[2];
}
my ($chr,$estart,$eend,$dstart,$dend,$key,$f);
while(<IN2>){
	chomp;
	my $a=$_;
	if($a=~/(.*)\:(\d+)\-(\d+).*/){
		$chr=$1;
		$estart=$2;
		$eend=$3;
	}
	$f=0;
	$chr=~s/re-//;
	foreach $key (keys %{$pos{$chr}}){
		if($key>$eend ||  $pos{$chr}{$key}<$estart){
			1;
		}
		else{
			$f=1;
		}
	}
	if($f==0){
		print "$a\n";
	}
}
close IN;
close IN2;	
