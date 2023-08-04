#########################################################################
# Author: Xingcheng Lin
# Created Time: Wed Jun 17 21:56:01 2020
# File Name: cmd.copyFile.sh
# Description: Copy the structure, phis and tms files from the 1ao7_template built each folders into the corresponding folders in this directory 
#########################################################################
#!/bin/bash

mkdir -p native_structures_pdbs_with_virtual_cbs
mkdir -p phis
mkdir -p tms

while read f
do
    echo $f
    cp ../$f/native_structures_pdbs_with_virtual_cbs/native.pdb native_structures_pdbs_with_virtual_cbs/${f}.pdb
#    cp ../$f/phis/phi_pairwise_contact_well_native_native_4.5_6.5_5.0_10 phis/phi_pairwise_contact_well_${f}_native_4.5_6.5_5.0_10
#    cp ../$f/phis/phi_pairwise_contact_well_native_decoys_TCR_randomization_4.5_6.5_5.0_10 phis/phi_pairwise_contact_well_${f}_decoys_TCR_randomization_4.5_6.5_5.0_10
    cp ../$f/phis/phi_pairwise_contact_well_native_native_6.5_8.5_5.0_10 phis/phi_pairwise_contact_well_${f}_native_6.5_8.5_5.0_10
    cp ../$f/phis/phi_pairwise_contact_well_native_decoys_TCR_randomization_6.5_8.5_5.0_10 phis/phi_pairwise_contact_well_${f}_decoys_TCR_randomization_6.5_8.5_5.0_10
    cp ../$f/tms/native.tm tms/${f}.tm


done < HLA0201_testing_list.txt
