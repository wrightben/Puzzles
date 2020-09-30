package CellsPM; 
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
our @EXPORT = qw( 
	@cells
	getIndex
	getRCBIndicies
	getCellValue
	setCellValue
	cellsTSV
); # Export by default ( adds to global namespace )
our @EXPORT_OK = qw( ); # Export on request ( ? )

my ($package, $filename, $line) = caller;


# BEGIN MODULE

# ABOUT THE MODULE:
# This module creates a stem-and-leaf using the regexes in @cells. 
# It lists the total # of each digit remaining to solve the puzzle
# It lists which cells are available for each index.
# It lists which boxes the cell indexes correspond to for each digit.

# Globals
# Hint: Use Excel

#	CELL INDICIES
# 		 0	 1	 2			 3	 4	 5			 6	 7	 8
# 		 9	10	11			12	13	14			15	16	17
# 		18	19	20			21	22	23			24	25	26
# 
# 		27	28	29			30	31	32			33	34	35
# 		36	37	38			39	40	41			42	43	44
# 		45	46	47			48	49	50			51	52	53
# 
# 		54	55	56			57	58	59			60	61	62
# 		63	64	65			66	67	68			69	70	71
# 		72	73	74			75	76	77			78	79	80

@indiciesByCellIndex = (
	# @indiciesByCellIndex[cellIndex] = @indicies[row,col,box]
	[ 0,9,18 ], [ 0,10,18 ], [ 0,11,18 ],	[ 0,12,19 ], [ 0,13,19 ], [ 0,14,19 ],	[ 0,15,20 ], [ 0,16,20 ], [ 0,17,20 ],
	[ 1,9,18 ], [ 1,10,18 ], [ 1,11,18 ],	[ 1,12,19 ], [ 1,13,19 ], [ 1,14,19 ],	[ 1,15,20 ], [ 1,16,20 ], [ 1,17,20 ],
	[ 2,9,18 ], [ 2,10,18 ], [ 2,11,18 ],	[ 2,12,19 ], [ 2,13,19 ], [ 2,14,19 ],	[ 2,15,20 ], [ 2,16,20 ], [ 2,17,20 ],
	
	[ 3,9,21 ], [ 3,10,21 ], [ 3,11,21 ],	[ 3,12,22 ], [ 3,13,22 ], [ 3,14,22 ],	[ 3,15,23 ], [ 3,16,23 ], [ 3,17,23 ],
	[ 4,9,21 ], [ 4,10,21 ], [ 4,11,21 ],	[ 4,12,22 ], [ 4,13,22 ], [ 4,14,22 ],	[ 4,15,23 ], [ 4,16,23 ], [ 4,17,23 ],
	[ 5,9,21 ], [ 5,10,21 ], [ 5,11,21 ],	[ 5,12,22 ], [ 5,13,22 ], [ 5,14,22 ],	[ 5,15,23 ], [ 5,16,23 ], [ 5,17,23 ],
	
	[ 6,9,24 ], [ 6,10,24 ], [ 6,11,24 ],	[ 6,12,25 ], [ 6,13,25 ], [ 6,14,25 ],	[ 6,15,26 ], [ 6,16,26 ], [ 6,17,26 ],
	[ 7,9,24 ], [ 7,10,24 ], [ 7,11,24 ],	[ 7,12,25 ], [ 7,13,25 ], [ 7,14,25 ],	[ 7,15,26 ], [ 7,16,26 ], [ 7,17,26 ],
	[ 8,9,24 ], [ 8,10,24 ], [ 8,11,24 ],	[ 8,12,25 ], [ 8,13,25 ], [ 8,14,25 ],	[ 8,15,26 ], [ 8,16,26 ], [ 8,17,26 ]
);

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


# TESTING
if ( ! $package ) {
# 	print join ", ", &getIndex(3);
# 	print ("\n" x 2);
# 	print join ", ", &getRCBIndicies(80);
# 	print ("\n" x 2);
# 	print setCellValue(1,57);
# 	print &cellsTSV;
}


# SUBROUTINES FOR RegexStemLeaf
# Requires @cells



# Return the array of cell indexes @indicies[$index];
sub getRCBIndicies {
	my $index = shift @_;
	return @{ $indiciesByCellIndex[$index] };
}

sub getIndex {
	my $index = shift @_;
	return @{$indicies[$index]}; # Return a list (separate vars, all at same level); Stores in array.
}

sub getCellValue {
	my $index = shift @_;
	return $cells[$index];
}

sub setCellValue {
	my ( $ref0, $ref1 ) = @_;
	return $cells[$ref0] = $ref1;
}

sub cellsTSV {
	return join "\t", @cells;
}


# END

1;