package RegexPM; 
# ^ This line creates the namespace for the symbols (subroutines, etc) in this file; Delete it to include all symbols in MAIN (global) namespace
# This module's "package" line ( package lib::WrightPM ) must match the "use" line ( use lib::WrightPM ) added to files that need this module if @Export is to work properly.
# The package line is the namespace; The use line is the path to the module. 
# Example:
#	package WrightPM;	(in lib/WrightPM.pm)
#	use lib::WrightPM;	(in SomeOtherFile.pl)

# GLITCH Warning: Can't find module? Try: $perl file.pl instead of $./file.pl

# EXPORT Notes
# Subroutines can be called by MAIN (not this package) without being @EXPORT or @EXPORT_OK by using the qualified namespace: &{WrightPM::moduleTest};

# MODULE Notes
# 1. The module will execute any code not in functions when the module is loaded.
# 2. Accessing variables from outer namespace: $main::varName or @main::varName


# VARS for this PACKAGE
require Exporter;
use Data::Dumper;

our @ISA = qw( Exporter );
our @EXPORT = qw( ); # Export by default ( adds to global namespace )
our @EXPORT_OK = qw( setRegexes ); # Export on request ( ? )

my ($package, $filename, $line) = caller;


# BEGIN MODULE

# ABOUT THE MODULE:
# This module accepts a list of arrays (permutations for each row, col, and box) and
# filters the arrays for each intersection of box-row or box-col

# Globals
@indicies = (
	
	# Row
					
	[ 1, 2, 3, 4, 5, 6, 7, 8, 9],#	0
	[10,11,12,13,14,15,16,17,18],#	1
	[19,20,21,22,23,24,25,26,27],#	2
	[28,29,30,31,32,33,34,35,36],#	3
	[37,38,39,40,41,42,43,44,45],#	4
	[46,47,48,49,50,51,52,53,54],#	5
	[55,56,57,58,59,60,61,62,63],#	6
	[64,65,66,67,68,69,70,71,72],#	7
	[73,74,75,76,77,78,79,80,81],#	8

	# Col
					
	[1,10,19,28,37,46,55,64,73],#	1 09
	[2,11,20,29,38,47,56,65,74],#	2 10
	[3,12,21,30,39,48,57,66,75],#	3 11 
	[4,13,22,31,40,49,58,67,76],#	4 12
	[5,14,23,32,41,50,59,68,77],#	5 13
	[6,15,24,33,42,51,60,69,78],#	6 14
	[7,16,25,34,43,52,61,70,79],#	7 15
	[8,17,26,35,44,53,62,71,80],#	8 16
	[9,18,27,36,45,54,63,72,81],#	9 17
	
	# Box
					
	[ 1, 2, 3,10,11,12,19,20,21],#	1 18
	[ 4, 5, 6,13,14,15,22,23,24],#	2 19
	[ 7, 8, 9,16,17,18,25,26,27],#	3 20
	[28,29,30,37,38,39,46,47,48],#	4 21
	[31,32,33,40,41,42,49,50,51],#	5 22
	[34,35,36,43,44,45,52,53,54],#	6 23
	[55,56,57,64,65,66,73,74,75],#	7 24
	[58,59,60,67,68,69,76,77,78],#	8 25
	[61,62,63,70,71,72,79,80,81],#	9 26
	
);

# "Real" Global with "Dummy" data
@cells = qw( 
89	3	4	5	28	6	7	29	1
1568	2	568	9	148	7	48	346	34
1689	16	7	148	1248	3	489	2469	5
2	4	158	18	9	158	3	7	6
568	9	568	7	3	458	1	45	2
3	7	15	14	6	2	459	459	8
4	8	2	3	5	9	6	1	7
16	156	39	2	7	14	45	8	39
7	15	39	6	148	148	2	345	349
);

@regexes;

# TESTING
if ( ! $package ) {	
	@regexes = &setRegexes;
	print Dumper \@regexes;
};



# SECTION: Functions

sub setRegexes {

	my ($ref0, @reg);
	
	$ref0 = shift @_ || \@cells;
	
	@cells = @{$ref0};

	# Rows (x9), Cols (x9), Boxes (x9)
	foreach my $i ( 0 .. 26 ) {	push @reg, getRegex( getIndex($i) );	}
	
	# Set the global | pseudo-global variable
	@{ "${package}::regexes" } = @reg;
	
	return @reg;

}


sub getRegex {
	
	my ( @cellList ) = @_;

	$regex = "";
	foreach $index ( @cellList ) {
		#$regex .= $regex .= '['.$cells[$item -1].']'; # SLOW: w/o pipe
		$regex .= '['. ( join '|',(split //,$cells[$index -1] ) ) . ']'; # FAST: w/ pipe
	}

	return $regex;
	
}


sub getIndex {
	# Perl in a nutshell ... 
	my $index = shift @_;
	return @{$indicies[$index]}; # Return a list (separate vars, all at same level); Stores in array.
}

1;