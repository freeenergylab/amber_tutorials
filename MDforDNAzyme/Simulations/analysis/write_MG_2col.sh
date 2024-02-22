#!/usr/bin/env bash
for k in 1 ; do
  for i in 1 ; do
    for m in 200 ; do
      for j in `seq 1 52`; do
        kname=DNAzyme_cluster"$k"_run"$i"_"$m"mM_MG_res_"$j"
        inname="$kname".dat
        outname="$kname"_2col.dat
        awk '{$2=$3="";print $0}' $inname > $outname
      done
    done
  done
done
