#########################################################################
# Author: Xingcheng Lin
# Created Time: Sat Feb 13 19:56:33 2021
# File Name: cmd.copyfiles.sh
# Description: 
#########################################################################
#!/bin/bash

mkdir -p results

while read f
do
    echo $f 
    # If Modeller can build the loop structure, use the optimized structure, otherwise, use the automodel built structure
    if [ -f "job.$f/$f.BL00010001.pdb" ]
    then
        cp job.$f/$f.BL00010001.pdb results/
    else
#        echo "no loop was found in $f"
        cp job.$f/$f.B99990001.pdb results/$f.BL00010001.pdb
    fi
done < HLA0201_testing_list.txt
