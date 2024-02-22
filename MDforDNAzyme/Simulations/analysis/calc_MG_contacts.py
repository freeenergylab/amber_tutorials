#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os, sys

outfilename = sys.argv[1]
print(f'The output file is {outfilename}.')

clusters = ["1"]
residues = range(1, 53)
concentrations = ["200"] #mM
runs = range(1, 2)

def format_results(cluster):
  clusterresults = {}
  for concentration in concentrations:
    contable = {}
    for residue in residues:
      contable[residue] = get_results(cluster, concentration, residue)
    clusterresults[concentration] = contable
  return clusterresults

def get_results(clu, con, res):
  contacts = 0
  frames = 0
  for run in runs:
    print(f'cluster: {clu}, runs: {run}, concentration: {con}, residue: {res}')
    kname = 'DNAzyme_cluster'+str(clu)+'_run'+str(run)+'_'+str(con)+'mM_MG_res_'+str(res)+'_2col.dat'
    infile = open(kname, "r")
    for line in infile.readlines():
      if not '#Frame' in line:
        frames += 1
        lparts = line.split("   ")[1] 
        distance = lparts.split("\n")[0]
        if float(distance) < 4:
          contacts += 1
    infile.close()
  percentage = contacts/frames
  result = round(percentage, 3)
  return result

def printtable(file):
  outfile = open(file, "w")
  outfile.write("residues PDB \t")
  for q in residues:
    outfile.write("\t"+str(q))
  outfile.write("\n")
  for a in clusters:
    outfile.write("cluster "+str(a)+"\n")
    for b in concentrations:
      outfile. write("concentration: "+str(b)+" mM")
      for c in residues:
        outfile.write("\t"+str(resultstable[a][b][c]))
      outfile.write("\n")
  outfile.close()

resultstable = {}
for clus in clusters:
  resultstable[clus] = format_results(clus)
printtable(outfilename)