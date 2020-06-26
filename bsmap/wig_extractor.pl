#!/usr/bin/perl
use Getopt::Long;
use Cwd;

my $filename;
my $parent_dir = getcwd();

my %fhs;
my %bases_cov;
my %bases_meth;
my ($cov_cutoff,$cov_file, $meth_file, $context, $cov_out, $meth_out) = process_commandline();

process_results_file();

sub process_commandline{
  my $cov_cutoff=1;
  my $cov_file=0;
  my $meth_file=0;
  my $context="cpg,chh,chg";
  #my $chrom_out;

  # Files to extract:
  # c -> Coverage
  # m -> Methylation
  # b -> Coverage + Methylation

  my $files_to_extract;
  my $command_line = GetOptions ( 'cutoff=i' => \$cov_cutoff,
				  'e|extract=s' => \$files_to_extract,
				  'context=s' => \$context,
				  #'chrom=s' => \$chrom_out,
				  'cov_out=s' => \$cov_out,
				  'meth_out=s' => \$meth_out);


  ### EXIT ON ERROR if there are errors with any of the supplied options
  unless ($command_line){
    die "Please respecify command line options\n";
  }

  ### no files provided
  unless (@ARGV){
    die "You need to provide a file to parse!\n";
  }
  $filename = $ARGV[0];

  ### no files to extract specified
  unless ($files_to_extract){
    die "You need to specify the file you want to extract!\n";
  }

  if ($files_to_extract eq "c" or $files_to_extract eq "b"){
		$cov_file=1;
	}
	if ($files_to_extract eq "m" or $files_to_extract eq "b"){
		$meth_file=1;
	} 
  return ($cov_cutoff,$cov_file, $meth_file, $context, $cov_out, $meth_out);
}

sub process_results_file{
    %fhs = ();
    #if (defined($chrom_out)){
    #  $chrom_out = "chr".$chrom_out;
    #  print "\n$chrom_out\n";
    #}
    warn "\nNow reading in input file $filename\n\n";
    open (IN,$filename) or die "Can't open file $filename: $!\n";
	
    my($dir, $output_filename, $extension) = $filename =~ m/(.*\/)(.*)(\..*)$/;
  
    ### OPENING OUTPUT-FILEHANDLES
    my $wig_cov = my $wig_meth = $output_filename;
    if ($cov_file == 1){
    	#$wig_cov =~ s/^/Coverage_/;
    	#$wig_cov = $dir."/".$wig_cov.".wig"; 
	open ($fhs{wig_cov},'>',$cov_out) or die "Failed to write to $cov_out $!\n";
	printf {$fhs{wig_cov}} ('track name="'.$output_filename.'" description="coverage per base" visibility=3 type=wiggle_0 color=50,205,50'."\n");
    } 
    if ($meth_file == 1){
    	$wig_meth =~ s/^/Methylation_/;
    	$wig_meth = $dir."/".$wig_meth.".wig";  
	open ($fhs{wig_meth},'>',$meth_out) or die "Failed to write to $meth_out $!\n";
	printf {$fhs{wig_meth}} ('track name="'.$output_filename.'" description="percentage methylation" visibility=3 type=wiggle_0 color=50,205,50'."\n");
    }
    
   
    while (<IN>){
		next if $. == 1;
	  	my ($chrom,$start,$strand,$cont,$coverage,$percentage_meth) = (split("\t"))[0,1,2,3,4,6];
		$chrom = "\L$chrom";
		if ("\U$chrom" !~ /CHR.*/){
		  $chrom = "chr".$chrom;
		}	
	  	next if $coverage < $cov_cutoff;
		#print "\n$chrom:$chrom_out\n";
		next if (defined($chrom_out) and ($chrom ne $chrom_out));
		#print "\n2\n";
		next if not ("\U$context" =~ $cont);
		#print "\n3\n";

	  	if (defined($last_chrom) and $last_chrom ne $chrom){
				write_files($last_chrom);
	  	}
			if ($cov_file == 1){
				$bases_cov{$start}=$strand.$coverage;
			}
			
			if ($meth_file == 1){
				$bases_meth{$start}=$strand.$percentage_meth;
			}
	  	
		  $last_chrom = $chrom;
   	}
   	write_files($last_chrom);
}



sub write_files(){
	my ($chrom) = @_;
	# modify chromosome name, if not starting with "chr.."
	

	if ($cov_file == 1){
		printf {$fhs{wig_cov}} ("variableStep chrom=".$chrom." span=1\n");
		for my $k1 (sort { $a <=> $b } keys %bases_cov){
			printf {$fhs{wig_cov}} ("%u\t%d\n",$k1, $bases_cov{$k1});
		}
			%bases_cov =();
	}
			
	if ($meth_file == 1){
		printf {$fhs{wig_meth}} ("variableStep chrom=".$chrom." span=1\n");
		for my $k1 (sort { $a <=> $b } keys %bases_meth){
			printf {$fhs{wig_meth}} ("%u\t%.2f\n",$k1, $bases_meth{$k1});			
		}
		%bases_meth =();
	}
}
	


