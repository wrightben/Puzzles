package StemLeafPM; 
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
our @EXPORT_OK = qw( doStemLeaf ); # Export on request ( ? )

my ($package, $filename, $line) = caller;


# BEGIN MODULE

# ABOUT THE MODULE:
# This module creates a stem-and-leaf using the regexes in @cells. 
# It lists the total # of each digit remaining to solve the puzzle
# It lists which cells are available for each index.
# It lists which boxes the cell indexes correspond to for each digit.

# Globals
@indexToBox = qw(
	1 1 1  2 2 2  3 3 3 
	1 1 1  2 2 2  3 3 3 
	1 1 1  2 2 2  3 3 3 

	4 4 4  5 5 5  6 6 6 
	4 4 4  5 5 5  6 6 6 
	4 4 4  5 5 5  6 6 6 

	7 7 7  8 8 8  9 9 9 
	7 7 7  8 8 8  9 9 9 
	7 7 7  8 8 8  9 9 9
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

# "Real" Global with "Dummy" data
@stemLeafData = (
	[ 9,13,18,19,21,22,29,30,32,47,48,63,64,68,73,76,77 ],
	[ 4,7,22,25 ],
	[ 16,17,65,71,74,79,80 ],
	[ 13,15,16,17,21,22,24,25,41,43,48,51,52,68,69,76,77,79,80 ],
	[ 9,11,29,32,36,38,41,43,47,51,52,64,69,73,79 ],
	[ 9,11,16,18,19,25,36,38,63,64 ],
	[  ],
	[ 0,4,9,11,13,15,18,21,22,24,29,30,32,36,38,41,76,77 ],
	[ 0,7,18,24,25,51,52,65,71,74,80 ]
);


# TESTING
if ( ! $package ) {

	# getStemLeafData
# 	@returnValues = &getStemLeafData;
# 	print Dumper \@returnValues;

	# getStemLeafDataByBox
# 	@returnValues = &getStemLeafDataByBox;
# 	@returnValues = &getStemLeafDataByBox( &getStemLeafData );
# 	@returnValues = &getStemLeafDataByBox( [ [ 9, 13, 18] ] );
# 	print Dumper \@returnValues;

	# outputStemLeafData
# 	&outputStemLeafData;
# 	&outputStemLeafData( &getStemLeafData );

	# outputStemLeafDataByBox
# 	&outputStemLeafDataByBox(&getStemLeafDataByBox);
# 	&outputStemLeafDataByBox(&getStemLeafDataByBox( [ [ 9, 13, 18] ] ));

# 	&doStemLeaf( \@cells );

	&digitGuess;
	
}


# SUBROUTINES FOR RegexStemLeaf
# Requires @cells

sub getStemLeafData {
	# 1. Using @cells, creates array @indexesForDigit: [ [ cellIndexes ], ... ]
	# 2. Using @cells, creates an array @need: [ count of each digit missing from puzzle ]
	# 3. Using @cells, creates $unknownCount: ( 9 x 9 ) - $knowns.

	# @cells - Global || Local
	my ($ref0);
	$ref0 = shift @_ || \@cells;
	@cells = @{$ref0};	

	# Vars - Local
	my (@need, @indexesForDigit, $unknownCount);  
	# @indexesForDigit = ( [], [], [], [], [], [], [], [], [] );
	@need = (9,9,9,9,9,9,9,9,9);
	$unknownCount = 0;

	foreach $i ( 0 .. 80 ) { # Cells
		my $cell = $cells[$i];
		if ( $cell =~ /\d\d+/ ) {
			$unknownCount += 1;
			my @digits = split //, $cell;
			foreach $digit ( @digits ) {
				push @{$indexesForDigit[$digit - 1]}, $i;
			}
		} elsif ( $cell =~ /^\d$/ ){
			$need[$cell -1] -= 1;
		}
	}

	return ( \@indexesForDigit, $unknownCount, \@need );

}


sub getStemLeafDataByBox {
	# Requires @stemLeafData
	# Creates @indexesForDigitByBox [ (digit) => [ (box) => [ (cell indexes) ... 

	# @stemLeafData - Global || Local
	my ($ref0);
	$ref0 = shift @_ || \@stemLeafData;
	@stemLeafData = @{$ref0};
	
	my @stemLeafDataByBox = (
# 		[ [],[],[],[],[],[],[],[],[] ], # Digit 1: Boxes [1..9]
# 		[ [],[],[],[],[],[],[],[],[] ], # Digit 2: Boxes [1..9]
# 		[ [],[],[],[],[],[],[],[],[] ], # ...								
	);

	foreach $i ( 0 .. $#stemLeafData ) { # @stemLeafData
		push @stemLeafDataByBox, [ [],[],[],[],[],[],[],[],[] ];
		my @array = @{ $stemLeafData[$i] };
		foreach $cellIndex ( @array ) {
			push @{ @{ $stemLeafDataByBox[$i] } [ $indexToBox[ $cellIndex ] -1 ] }, $cellIndex; 
		}
	}
	
	return \@stemLeafDataByBox;
}


sub outputStemLeafData {

	my  ($ref0, $ref1, $ref2, @data, @need, @strings, $unknownCount );
	
	# @_: Expects output of &getStemLeafData
	$ref0 = @_[0] || \@stemLeafData;
	$ref1 = @_[1] || 82;
	$ref2 = @_[2] || [3,4,5,1,2,3,7,8,9];
	
	@data = @{ $ref0 };
	$unknownCount = $ref1;
	@need = @{ $ref2 };

	# @strings: The string representation of all cells that each digit [1..9] can go in.
	# Create strings from data for output
	my (@strings);
	$inc = 0;
	foreach $arr0 (@data) {
		push @strings, "[ " . ( join ",", @{ $arr0 } ) . " ]"; # Concat output
	}

	print (
		"Regex Stem-Leaf\n",
		"Outputs a hash of { digit => [cellIndexAvailable] .. }",
		("\n" x 2),
		( join "\n", @strings),
		("\n" x 2),
		"Unknown Count: $unknownCount"
	);

	print( 
		("\n" x 1),
		"Need Count (# of each digit required to finish puzzle)",
		("\n" x 1),
		( join ", ", @need), # @need: The string representation of how many of each digit [1..9] are missing from puzzle; (9 x 9) = 81 - $knowns = $unknownCount.
		("\n" x 2)
	);
	
}


sub outputStemLeafDataByBox {
	
	# About outputStemLeafDataByBox: ↓
	# Calling this method: &outputStemLeafDataByBox( &getStemLeafDataByBox( &getStemLeafData( \@cells ) ) )

	$ref0 = shift @_ || 0; die "Error: No data provided for &outputStemLeafDataByBox\n" if (! $ref0 ); 
	my @data = @{$ref0};
	
	print( 
		"Outputs [ Digit # => [ Box # => [ Cell #s ] ... ",
		("\n" x 1),		
		"digit-box [indexes]",
		("\n" x 1)
	);	
	
	$c1 = 0;
	foreach my $_ref0 ( @data ) { # Each Digit
		my @arr0 = @{ $_ref0 };
		
		$c1 ++;
		$c2 = 0; 
		foreach $_ref1 ( @arr0 ) { # Each Box 
		
			my @arr1 = @{ $_ref1 };
			$c2 ++;
			print(
				("\n" x 1),
				"$c1-$c2", 
				" [", ( join ", ", @arr1 ), "]"
			) if ( scalar @arr1 > 0 );

		}
	
	}

	print ("\n" x 1);
	return 1;
	
}


sub doStemLeaf {

	# @cells - Global || Local
	my ($ref0);
	$ref0 = shift @_ || \@cells;
	@cells = @{$ref0};	

	my ($a, $b, $c);
	($a, $b, $c) = &getStemLeafData;
	
	&outputStemLeafData( $a, $b, $c );
	&outputStemLeafDataByBox( &getStemLeafDataByBox( $a ) );
	
	return 1;
	
}


# For any 1 digit
# Guess per box
# Eliminate affected cells
# Repeat until all needed digits are paired with cell index
sub digitGuess {

	my @returnValues0 = &getStemLeafData;
	my @digitIndexes = @{$returnValues0[0]}[0];
	my $needed = @{$returnValues0[2]}[0];
	my @digitIndexesByBox = &getStemLeafDataByBox( [ @digitIndexes ] );

	print $needed;
	print Dumper @digitIndexes;
	print Dumper @digitIndexesByBox;

}


# END

1;