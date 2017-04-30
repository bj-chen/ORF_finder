#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( min max );
use Cwd qw(cwd);


my $dir = cwd;
my $orf_path = $ARGV[0];
my $input = $ARGV[1]; #input file to be in BED format;
my $chr_path = $ARGV[2]; #path to the folder that contains the chromosome fasta files;
my $OUTFILE = "$dir/output.txt";

my $tmp_fasta = "$dir/orf_tmp.fasta";

open (INPUT, $input) or die ("Unable to locate $input . \n");

open (OUTFILE, ">$OUTFILE") or die ("Unable to write to $OUTFILE.\n");

my %chr_dict;

sub main {
	
	my @chr_list;
	
# READ in the input line:

	while (<INPUT>) {
		
		chomp;
		
		my @input_entry = split /\t/;
		
		my $chr = $input_entry[0]; 
		my $start = $input_entry[1];
		my $end = $input_entry[2];
		
		#check if the chromosome sequence is already in the list:
		
		if #exist: 
		(grep $_ eq $chr, @chr_list)
		{fasta($chr,$start,$end);
			orf($chr,$start,$end);}
		
		else #not in the list yet: 
		{
			my $file = "$chr_path/" . $chr . ".fa";
			open (DICT, $file) or die ("Unable to open the $file\n");
			my $chr_seq;
			<DICT>;
			while (my $seq1 = <DICT>) {
			
			chomp $seq1;			
			$chr_seq = $chr_seq . $seq1;	
				}			
			$chr_dict{$chr} = $chr_seq; #add the chromosome sequence to the array of dictionaries;
			close DICT;
			push @chr_list, $chr; #push the chr name to the chr_list array;
			
			{fasta($chr,$start,$end);
			 orf($chr,$start, $end);}
			}
				
		}
		
		
		close INPUT;
		close OUTFILE;
		}


sub fasta {	
	
	
	my $chr_q = shift;
	my $start_q = shift;
	my $end_q = shift;
	
	
			my $query_seq = substr $chr_dict{$chr_q}, ($start_q-1), ($end_q - $start_q + 1);	
			
			open (FASTA, ">$tmp_fasta") or die ("Unable to write to the $tmp_fasta\n");		
			print FASTA ($query_seq);
								
			close FASTA;
	}		


sub orf {						
				my $chr_o = shift;
				my $start_o = shift;
				my $end_o = shift;
	
				my $cmd = "$orf_path/ORFfinder";				
				my $ORF_out = "$dir/orf_output.txt";
				my $stdErr = "$dir/error.txt";
				
				my $fullCmd = "$cmd -in $tmp_fasta -ml 30 -out $ORF_out 2>$stdErr";
				system($fullCmd);
				
				if (-z $ORF_out) #if there is an empty output file produced, i.e. no ORF found;
				{unlink $stdErr; #remove the standard error file;	
					unlink $ORF_out;				
					unlink $tmp_fasta;
					
					print OUTFILE ($chr_o . "\t" . $start_o . "\t" . $end_o . "\t" . "No ORF" . "\n");}
					
				
				else {
					
					open (ORF, $ORF_out) or die ("No ORFfinder output found");
				
					<ORF>;
				
					my $orf_seq;
					my @orf_array;
				
					while (my $orf_line = <ORF>) {
										
					chomp $orf_line;
									
					if ((substr $orf_line, 0, 1) eq ">") {push @orf_array, $orf_seq; $orf_seq=();}
						else {$orf_seq = $orf_seq . $orf_line;
								if (eof(ORF)) {push @orf_array, $orf_seq;$orf_seq=();}	}							
						}  
					
					close ORF;
					
					my @length_array;
					
					foreach my $data(@orf_array) {push @length_array, length($data);}
						
					my $max = max @length_array;
											
					print OUTFILE ($chr_o . "\t" . $start_o . "\t" . $end_o . "\t" .  $max .  "\n"); 				
														
					unlink $tmp_fasta;							
					unlink $ORF_out; #remove the ORF output file;
					close $stdErr;
					unlink $stdErr;		
								}}


main();
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
