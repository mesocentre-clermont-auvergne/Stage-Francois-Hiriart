BSMAP 2.6 Wrapper
Written by Eugen Eirich @ Institute of Molecular Biology Mainz
Contact: e.eirich@imb-mainz.de

1. Dependencies
To use the wrapper, please install BSMAP 2.6 and the Samtools package manually to your dependencies directory.

2. Reference genomes
You can either use reference genomes from your history or built-in genomes. The built-in genomes are specified
in the file "bsmap_fasta.loc" in your tool-data directory.

3. WIG parser
There is a WIG parser included in the repo, which converts the BSMAP Methylation Caller ouptut into WIG format. 
To use this parser, please first path the file "methratio.py" in your BSMAP directory with the included file
"methratio.patch":

/path/to/bsmap/methratio.py < methratio.patch