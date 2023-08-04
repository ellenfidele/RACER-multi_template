#!/bin/bash

# Create evaluateE_use_same_gammas.py
cp evaluateE_use_same_gammas.py for_bindingE/loocv/evaluateE_use_same_gammas.py

# Copy the trained gammma file in
#cp ./for_training_gamma/gammas/randomized_decoy/native_trainSetFiles_phi_pairwise_contact_well6.5_8.5_5.0_10_gamma_filtered for_bindingE/loocv/gammas/randomized_decoy/native_trainSetFiles_phi_pairwise_contact_well6.5_8.5_5.0_10_gamma_filtered

cd for_bindingE/loocv/

# Evaluate the binding energies for native and decoy binders
python evaluateE_use_same_gammas.py

mkdir -p results/
mv enative.*.txt emg.*.txt zscore.*.txt results/

cd ../../

