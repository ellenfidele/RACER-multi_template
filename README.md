[![DOI](https://zenodo.org/badge/674437478.svg)](https://zenodo.org/badge/latestdoi/674437478)

# RACER-m
Rapid Coarse-grained Epitope TCR Model(multi-template)

This model is the adapted version of [RACER](https://github.com/XingchengLin/RACER) with implementation of multi-template training/testing strategy. 

## Installation

* Clone the RACER-m repository
```
git clone https://github.com/ellenfidele/RACER-multi_template.git
```

### Python version
This model is implemented with Python 3.9.12 

### Package dependencies
* Modeller: [https://salilab.org/modeller/](https://salilab.org/modeller/)
* Numpy (1.21.2): [https://numpy.org/](https://numpy.org/)
* Biopython (1.79): [https://biopython.org](https://biopython.org)
* Pandas (2.0.0): [https://pandas.pydata.org/](https://pandas.pydata.org/)

## Usage

### Step 0: Prepare input files

Prepare input file with peptide/CDR3Alpha/CDR3Beta sequences for each entry, as well as the best structural template for the 3D structure construction via Modeller. An example file can be found in `supplymentary_script/MasterList_2023_best_template`. This preparation step can be done in with a script in `supplymentary_script`

* To prepare for the structural threading using Modeller, the lengths of Peptide/CDR3Alpha/CDR3Beta sequences in input files containing testing sequences (`MasterList_2023_best_template`) should be consistent with the lengths in the reference file (`MasterList_2023_reference_template`). This can be done with the following command in directory `supplymentary_script`:
```
python3 prep_threading_input.py --list_file MasterList_2023_best_template --ref_file MasterList_2023_reference_template --out_path ./
```
which will save the output files as `MasterList_2023_reference_template_adjusted` and `MasterList_2023_best_template_adjusted`.

* Copy the output files(e.g. `MasterList_2023_reference_template_adjusted` and `MasterList_2023_best_template_adjusted`) to `./structures` directory

```
cp {MasterList_2023_reference_template_adjusted,MasterList_2023_best_template_adjusted} ../structures/
```

### Step 1: Build structures from sequences 

In this step, [Modeller](https://salilab.org/modeller/) will be used for building structures from sequences of peptide/CDR3Alpha/CDR3beta and selected template structure.

* Change directory to `./structures`

* Start building structures with the following command:
```
bash cmd.modeller.sh <list_file_name> <template_file_name>
```
Example:
```
bash cmd.modeller.sh MasterList_2023_best_template_adjusted MasterList_2023_reference_template_adjusted
```
Threaded structures will be saved in directory `structures/modeller/results`

### Step 2: Calculate contacts in threaded structures

* Change directory to `optimization_r_max_8.5`

* Run the calculation with the following command
```
bash cmd.do_optimization.sh
```
Output files will be saved in `optimization_r_max_8.5/for_bindingE/loocv`.

### Step 3: Evaluate the pseudo-binding-energy and zscores

* In the directory `optimization_r_max_8.5`, use the following command to do the evaluation:
```
bash cmd.evaluate_bindingE.sh
```
This command evaluates the pseudo-binding-energy and z scores using the pre-trained energy model. The model parameteres are saved in  `for_bindingE/loocv/gammas/randomized_decoy/native_trainSetFiles_phi_pairwise_contact_well6.5_8.5_5.0_10_gamma_filtered`.
