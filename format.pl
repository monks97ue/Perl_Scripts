#!/usr/bin/perl
##########################################
# Inputs
##########################################
if ( $#ARGV != 0 ) {
    print "Usage: format.pl hsp.out ;\n";
    exit 1;
}
$hspout = $ARGV[0];

## Extract data
open (IN, "$hspout");
$idblk = 0;
$dblk_start = 0;
$var_step = 'None';
$match_pat = ' vpwr ';
$skip_line = '10';
@{$var_step} = ();
$filename="";
print "$match_pat\n";
while (<IN>) {
	chomp;
	$line = $_; 
	@main=();
	print $line."\n";
#	if ( $line =~ /^mix/ ) {
#	    $header=$line;
#	    $header =~ s/mix_fo3_10nm_//g;
#	    $header =~ s/vpwr_swp_tttt_temp_//g;
#	    $header =~ s/\.mt.*/	/g;
#	    $header =~ s/_/ /g;
#	}

	if ( $line =~ /$match_pat/ ) {
#	    print "Match found $match_pat\n";
	    for ($i=0;$i<$skip_line;$i++) {
		$mainln[$i]=<IN>;
#		print "loop 1: $main[$i]\n";
#		print "\$i is $i\n";
		$mainln[$i] =~ s/\n//g; #Get ride of end line character 
	    }
	    for ($i=0;$i<$skip_line;$i++) {
		$mainln[$i] .= <IN>;    #concatenate the 11th line to the 1st line etc
		$mainln[$i] =~ s/\n//g;
#		print "$header".$mainln[$i]."\n";
		print $mainln[$i]."\n";
	    }
	}
}

