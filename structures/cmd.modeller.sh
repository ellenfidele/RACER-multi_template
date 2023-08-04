#########################################################################
# Author: Xingcheng Lin
# Created Time: Tue Dec 24 17:54:26 2019
# File Name: cmd.sh
# Description: 
#########################################################################
#!/bin/bash

LISTFILE=$1
TEMPFILE=$2

awk '{print $1}' $LISTFILE > modeller/HLA0201_testing_list.txt

export Num_lines=`wc -l ${LISTFILE} | awk '{print $1}'`

for ((i=1; i<=$Num_lines; i++))
do
    echo $i
    
    # Extract the name, sequences of peptide and CDR3A/B for each case

    echo "*** Extracting target peptide/CDR3A/B sequence"
    TCR_name=`cat ${LISTFILE} | awk -v var="$i" '{if(NR==var)print $1}'`
    PEP_SEQ=`cat ${LISTFILE} | awk -v var="$i" '{if(NR==var)print $2}'`
    CDR3A_SEQ=`cat ${LISTFILE} | awk -v var="$i" '{if(NR==var)print $3}'`
    CDR3B_SEQ=`cat ${LISTFILE} | awk -v var="$i" '{if(NR==var)print $4}'`
    TEMPLATE_name=`cat ${LISTFILE} | awk -v var="$i" '{if(NR==var)print $5}'`

    # Find and extract the peptide/CDR3A/B sequences from the template crystal structure
    echo "*** Extracting template peptide/CDR3A/B sequence"
    ref_PEP_seq=`grep "$TEMPLATE_name" ${TEMPFILE} | awk '{print $2}'`
    ref_CDR3A_seq=`grep "$TEMPLATE_name" ${TEMPFILE} | awk '{print $3}'`
    ref_CDR3B_seq=`grep "$TEMPLATE_name" ${TEMPFILE} | awk '{print $4}'`

    rm -r modeller/job.$TCR_name
    mkdir -p modeller/job.$TCR_name
    cp template/* modeller/job.$TCR_name/
    cd modeller/job.$TCR_name/

    # Find and copy template crystral structure to current directory
    cp ../../../PDBs/${TEMPLATE_name}.trunc.fitRenumberResidues.pdb ${TEMPLATE_name}.pdb
    echo "*** Copied template crystal structure ${TEMPLATE_name}.pdb"
    
    # Get the template sequence
    echo "*** Getting template sequence"
    python ../../../buildseq.py $TEMPLATE_name 

    # Clean the sequence
    python cleanSeq.py ${TEMPLATE_name}.seq ${TEMPLATE_name}_clean.seq

    # Create the template_alignment.ali
    echo "*** Creating template_alignment.ali"
    echo "*** template name and seqs are:  ${TEMPLATE_name} ${ref_PEP_seq} ${ref_CDR3A_seq} ${ref_CDR3B_seq}"
    python copy_seq_fortemplate.py ${TEMPLATE_name}_clean.seq template_alignment.ali $TEMPLATE_name $ref_PEP_seq $ref_CDR3A_seq $ref_CDR3B_seq

    # Create the template_fillres.py, adding in the templates
    if [[ "$current_line_number" < "$num_lines" ]]
    then
        SRC="TEMPLATE_PDBID"
        DST="'$TEMPLATE_name',TEMPLATE_PDBID"
        sed "s/$SRC/$DST/g" template_template_fillres.py > tmp.py
        mv tmp.py template_template_fillres.py 
    else
        SRC="TEMPLATE_PDBID"
        DST="'$TEMPLATE_name'"
        sed "s/$SRC/$DST/g" template_template_fillres.py > template_fillres.py
    fi

    # Create the target sequence, using the framework of the template crystal structure
    echo "*** Creating target sequence"
    python copy_seq_fortarget.py ${TEMPLATE_name}_clean.seq template_alignment.ali $TEMPLATE_name $ref_PEP_seq $ref_CDR3A_seq $ref_CDR3B_seq
    
    # Complete the alignment.ali with the target peptide/CDR3A/B sequences inserted
    echo "*** Creating alignment.ali"
    sed "s/CDR3ASEQ/$CDR3A_SEQ/g; s/CDR3BSEQ/$CDR3B_SEQ/g; s/PEPTIDESEQ/$PEP_SEQ/g; s/TCRNAME/$TCR_name/g" template_alignment.ali > alignment.ali

    # Remove the carriage return
    gsed -i 's/^M//g' alignment.ali
    sed "s/TCRNAME/$TCR_name/g" template_fillres.py > fillres.py

    python fillres.py

    # cp $TCR_name.BL00010001.pdb test.$i.pdb

    cd ../../

    cd modeller
    bash cmd.copyfiles.sh
    cd ..
done
