###########################################################################
# This script will copy the cleaned template sequence and list the target sequence
# for the file template_alignment.ali
#
# Written by Xingcheng Lin, 03/13/2021;
###########################################################################

import time
import subprocess
import os
import math
import sys
import numpy as np

def copy_seq_fortemplate(inputFile, outputFile, pdb_id, template_peptide, template_cdr3a, template_cdr3b):

    infile = open(inputFile, 'r')
    outfile = open(outputFile, 'a')

    cdr3a_seq = template_cdr3a
    cdr3a_seq_orig = template_cdr3a.replace("-", "")

    cdr3b_seq = template_cdr3b
    cdr3b_seq_orig = template_cdr3b.replace("-", "")

    pep_seq = template_peptide
    pep_seq_orig = template_peptide.replace("-", "")


    # Find the position of the sequences in the given template string
    lines = [line.strip() for line in infile]
    infile.close()

    # The template sequence should be in the third line
    template_sequence = lines[2]

    # Replace the original CDR3A/CDR3B/peptide sequence with the CDR3ASEQ/CDR3BSEQ/PEPTIDESEQ, for next Modeller replacement;
    tmp_seq = template_sequence.replace(cdr3a_seq_orig, "CDR3ASEQ")
    tmp_seq = tmp_seq.replace(cdr3b_seq_orig, "CDR3BSEQ")
    forModeller_template_sequence = tmp_seq.replace(pep_seq_orig, "PEPTIDESEQ")

    # Output target sequence
    outfile.write(">P1;TCRNAME" + "\n")
    outfile.write("sequence:::::::::" + "\n")

    outfile.write(forModeller_template_sequence + "\n")
    outfile.close()


############################################################################

if __name__ == "__main__":
    # Cleaned template sequence
    inputFile = sys.argv[1]
    # template_alignment.ali
    outputFile = sys.argv[2]
    # PDB id of the corresponding template
    pdb_id = sys.argv[3]
    template_peptide = sys.argv[4]
    template_cdr3a = sys.argv[5]
    template_cdr3b = sys.argv[6]

    copy_seq_fortemplate(inputFile, outputFile, pdb_id, template_peptide, template_cdr3a, template_cdr3b)
    
    print("When the voice of the Silent touches my words,")
    print("I know him and therefore know myself.")
