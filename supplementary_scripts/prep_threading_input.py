import pandas as pd
import argparse


parser = argparse.ArgumentParser(description='Modify the input files to align the lengths of sequence of Peptide/CDR3Alpha/CDR3Beta in them.')


parser.add_argument('--list_file', type=str, help='Path and file name of the list file. List file should have 5 columns of data with the MIDDLE 3 columns being the sequences of [Peptide], [CDR3Alpha] and [CDR3Beta] respectively.')
parser.add_argument('--ref_file', type=str, help='Path and file name of the reference file. Reference file should have 4 columns of data with the LAST 3 columns being the sequences of [Peptide], [CDR3Alpha] and [CDR3Beta] respectively.')
parser.add_argument('--out_path', type=str, help='Path to save the output files.')


#args = parser.parse_args('--list_file RACER_v2_precise_template/structures/MasterList_2023_best_template.csv --ref_file RACER_v2_precise_template/structures/MasterList_2023_reference_template.csv --out_path ./RACER_v2_precise_template/structures/'.split())
args = parser.parse_args()


list_file_nm = args.list_file
ref_file_nm = args.ref_file


list_file = pd.read_csv(list_file_nm, sep='\s+', header=None)
ref_file = pd.read_csv(ref_file_nm, sep='\s+', header=None)
ref_file.columns = ['Name', 'Peptide', 'CDR3Alpha', 'CDR3Beta']
list_file.columns = ['Name', 'Peptide', 'CDR3Alpha', 'CDR3Beta', 'best_template']


ref_file.Peptide = ref_file.Peptide.str.rstrip('-')
ref_file.CDR3Alpha = ref_file.CDR3Alpha.str.rstrip('-')
ref_file.CDR3Beta = ref_file.CDR3Beta.str.rstrip('-')


list_file.Peptide = list_file.Peptide.str.rstrip('-')
list_file.CDR3Alpha = list_file.CDR3Alpha.str.rstrip('-')
list_file.CDR3Beta = list_file.CDR3Beta.str.rstrip('-')


list_max_len_peptide = max(list_file.Peptide.str.len())
list_max_len_cdr3a = max(list_file.CDR3Alpha.str.len())
list_max_len_cdr3b = max(list_file.CDR3Beta.str.len())

ref_max_len_peptide = max(ref_file.Peptide.str.len())
ref_max_len_cdr3a = max(ref_file.CDR3Alpha.str.len())
ref_max_len_cdr3b = max(ref_file.CDR3Beta.str.len())


final_peptide_len = max(list_max_len_peptide, ref_max_len_peptide)


final_CDR3a_len = max(list_max_len_cdr3a, ref_max_len_cdr3a)
final_CDR3b_len = max(list_max_len_cdr3b, ref_max_len_cdr3b)


ref_file.Peptide = ref_file.Peptide.str.pad(width=final_peptide_len, side='right', fillchar='-')
ref_file.CDR3Alpha = ref_file.CDR3Alpha.str.pad(width=final_CDR3a_len, side='right', fillchar='-')
ref_file.CDR3Beta = ref_file.CDR3Beta.str.pad(width=final_CDR3b_len, side='right', fillchar='-')


list_file.Peptide = list_file.Peptide.str.pad(width=final_peptide_len, side='right', fillchar='-')
list_file.CDR3Alpha = list_file.CDR3Alpha.str.pad(width=final_CDR3a_len, side='right', fillchar='-')
list_file.CDR3Beta = list_file.CDR3Beta.str.pad(width=final_CDR3b_len, side='right', fillchar='-')


ref_out_filenm = ref_file_nm.split('/')[-1] + '_adjusted'
list_out_filenm = list_file_nm.split('/')[-1] + '_adjusted'


ref_out_filenm


ref_file.to_csv(f'{args.out_path}/{ref_out_filenm}', header=None, index=None, sep='\t')
list_file.to_csv(f'{args.out_path}/{list_out_filenm}', header=None, index=None, sep='\t')

print(f'Files saved to {args.out_path}/{ref_out_filenm} and {args.out_path}/{list_out_filenm}')
