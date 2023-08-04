#########################################################################
# Author: Xingcheng Lin
# Created Time: Thu Jun 18 22:59:21 2020
# File Name: cmd.sh
# Description: 
#########################################################################
#!/bin/bash

while read f
do
    echo $f 
    cp ../../structures/modeller/results/$f.BL00010001.pdb native.pdb
    # Extract the B chain, after the Modeller built, which is the peptide (thanks for the formatting of TCR3d);
    # ExtractFromPDBFiles.pl -o --mode Chains --chains B native.pdb
    awk '{ if ($5=="B") print $0}END{print "END"}' native.pdb > ChainB.pdb 
    printf "HEADER\n" | cat - ChainB.pdb > nativeChainB.pdb
    pResid_startID=`cat nativeChainB.pdb | awk '{if(NR==2)print $6}'`
    tail -3 nativeChainB.pdb | head -1 > tmp.txt
    pResid_endID=`cat tmp.txt | awk '{print $6}'`
    # Copy the template folder into the PDB folder
    cp -r template $f
    # update the cmd.optimization.sh file the residue ID of peptide and PDB id of the corresponding PDB folder;
    echo $f $pResid_startID $pResid_endID
    sed "s/PDBID/$f/g; s/P_RESID_STARTID/$pResid_startID/g; s/P_RESID_ENDID/$pResid_endID/g" template_cmd.optimization.sh > $f/cmd.optimization.sh

    # Copy the cmd.preprocessing.sh file into the corresponding folder
    cp cmd.preprocessing.sh $f/

    cd $f/
    bash cmd.optimization.sh
    cd ../
done < HLA0201_testing_list.txt


