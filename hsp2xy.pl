#!/usr/bin/perl
##########################################
# Inputs
##########################################
if ( $#ARGV != 0 ) {
    print "Usage: hsp2xy.pl hsp.out ;\n";
    exit 1;
}
$hspout = $ARGV[0];

## Extract data
open (IN, "$hspout");
$idblk = 0;
$dblk_start = 0;
$var_step = 'None';
@{$var_step} = ();
while (<IN>) {
	$line = $_; 

	$line =~ s/^\s//g;
	if ( $line =~ /\*\*\*\s+source\s+(\S+)\s+=\s+(\S+)/ ) {
		@fields = split ":", $1;
		$var_step = $fields[1];
		$var_step_value = $2;
		$var_step_value =~ s/m/e-3/g;
		$var_step_value =~ s/n/e-9/g;
		$var_step_value =~ s/u/e-6/g;
		$var_step_value =~ s/f/e-15/g;
		$var_step_value =~ s/p/e-12/g;
		$var_step_value =~ s/k/e3/;
		push (@{$var_step}, $var_step_value);
		next;
	}

	if ( $line =~ /^x\s+?$/ ) {
		$dblk_start = 1;
		$idblk++;

		$dblkname = join "_", 'data', $idblk; 
		push (@dblk_names, $dblkname);

		@{$dblkname} = ();
		next;
	}

#	if ( $line =~ /^\s+volt\s+\S+/ ) {
#		print "% $line"; 
#	}

	if ( ($line =~ /\s*\S+\s+\S+/) && ($dblk_start > 0) ){
		$line =~ s/^\s//g;
		if ( ! (( $line =~ /^\s*\d/) || ( $line =~ /^\s*-\d/)) ) {
			push(@{$dblkname}, "$line");
			next;
		}

		$line =~ s/m/e-3/g;
		$line =~ s/u/e-6/g;
		$line =~ s/n/e-9/g;
		$line =~ s/p/e-12/g;
		$line =~ s/f/e-15/g;
		$line =~ s/a/e-21/g;
		$line =~ s/k/e3/;
		push(@{$dblkname}, $line);
	} 

	if ( $line =~ /^y\s+$/ ) {
		$dblk_start = 0;
	}
}

# ## Extract device info
# $hspinp = $hspout; 
# $hspinp =~ s/(.*)\.\S+/$1\.input/; 
# @devinfo_input = `egrep "M1 |WID|LEN|temp|\.lib" $hspinp |grep -v "*"|grep -v base`;
# for $line (@devinfo_input) {
# 	if ( $line =~ /LEN=(\S+)/ ) {
# 		$L = $1;
# 	}
# 	if ( $line =~ /WID=(\S+)/ ) {
# 		$W = $1;
# 	}
# 	if ( $line =~ /\.temp\s+(\S+)/ ) {
# 		$T = $1;
# 	}
# 	if ( $line =~ /(\S+)\s+W=/ ) {
# 		$dev = $1;
# 	}
# 	if ( $line =~ /.lib\s+\'(\S+)\'\s+(\S+)/ ) {
# 		$str1 = $1;
# 		$str2 = $2; 
# 		if ( $str2 =~ /[a-z]n[a-z]p/ ) {
# 			$lib = $str1;
# 			$cor = $str2;
# 		}
# 	}
# 	
# }

##################################################
# Output
##################################################
#print "% Converted from $hspout by hsp2mat.pl\n\n"; 
#print "varname_step = '$var_step';\n";
#print "var_step = [", join(" ", @{$var_step}), "];\n"; 
#print "iv_blks = str2mat('", join("','", @dblk_names), "');\n"; 
#print "title_txt = '$dev,W${W}L${L},$lib,$cor,$T';\n";

foreach $dblk (@dblk_names) {
    #print "\n$dblk = [\n";
	for $dline (@{$dblk}) {
		if ( $dline =~ /^\s+v/i ) {
			print "$dline"; 
		} else {
			print $dline;
		} 
	}
	#print "]; \n"; 
}
