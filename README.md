# ORF_finder

This is a wrapper in Perl for finding the maximum length of ORFs a DNA sequence using NCBI's ORF finder tool (downloadable at ftp://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/);

Input file must be in the BED format, in which each line consists of:

chrom - The name of the chromosome (e.g. chr3, chrY, chr2_random);

chromStart - The starting position of the feature in the chromosome; and

chromEnd - The ending position of the feature in the chromosome.  

The above three fields are separated by tab.  

Usage:

In the directory where this script resides:

./ORF_finder.pl \<ORF_PATH> \<INPUT> \<CHR_PATH>

\<ORF_PATH>: path to the directory where the NCBI's ORF finder tool is located;

\<INPUT>: path and file name of the input file;

\<CHR_PATH>: path to the directory containing DNA sequence of each chromosome.  For example: the assembly of human genome hg38 can be downloaded at: http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/.

The output file will be a "output.txt" file under current directory.


