#!/bin/bash
cp ../structures/modeller/HLA0201_testing_list.txt ./for_bindingE
cp ../structures/modeller/HLA0201_testing_list.txt ./for_bindingE/loocv

cd for_bindingE/

# Create cmd.for_phi.sh
#sed "s/TEMPLATE_PDBID/$f/g" template_cmd.for_phi.sh > cmd.for_phi.sh
cp template_cmd.for_phi.sh cmd.for_phi.sh
# Run to generate phi file
bash cmd.for_phi.sh

# Copy the generated phi into the loocv folder
cd loocv/
bash cmd.copyFile.sh
cd ../

# Delete the target folder for saving space, only delete after training is complete
# bash cmd.delete.sh
cd ../
