# This script will get argument passed by command line;
import sys
from modeller import *
# Get the sequence of the PDB file, and write to an alignment file
code = sys.argv[1]

e = Environ()
m = Model(e, file=code)
aln = Alignment(e)
aln.append_model(m, align_codes=code)
aln.write(file=code + '.seq')
