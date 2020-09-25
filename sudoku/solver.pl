#!/usr/bin/perl5.28
use Data::Dumper;
use lib::RegexPM;
use lib::IntersectionsPM;
use lib::StemLeafPM;

# SECTION: GLOBAL VARIABLES
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

@regexes = (		# 27 regular expressions
	# Row 0-8
	# Col 0-8
	# Box 0-8
); 

@permutations = (	# 27 @arrays of grepped permutations
	# Row 0-8
	# Col 0-8
	# Box 0-8
);

@state = ( 0 ); # Save puzzle states for guessing; 0 = no initial state

# END




# SECTION: CONFIG, .TSV (puzzle), and SOLVER

# config
$error		= 0; # [0=none, 1=fail, 2=inspect]
$guessing	= 1; # [y=1,n=2]; non-deterministic puzzles ( no single solution, etc )
$update		= 0;
$maxIterations	= 25;
$iteration	= 1;
$file		= './permutations/permutations.txt';
@file_list	= split /\n/,`cat "${file}"`;

@cells = qw(
.	.	4	.	.	6	.	.	1
.	2	.	9	.	7	.	.	.
.	.	.	.	.	3	.	.	5
.	.	.	.	.	.	3	.	6
.	9	.	7	.	.	1	.	.
3	7	.	.	.	.	.	.	8
4	.	.	.	5	.	.	.	.
.	.	.	2	.	.	.	8	.
7	.	.	6	.	.	2	.	.
);

# Solver
&outputPuzzleTSV;
&setDotCellValues;	# WRITES to @Cells
&saveState;
&iterate;

# Log
print ("\n" x 2); &outputPermutations(0);	
&{StemLeafPM::doStemLeaf}(\@cells);


sub iterate {

	while (	( &getKnownCount != 81 ) && # 81 = solved
		( ( $state[$#state] ne $state[$#state - 1] ) || ( $update == 1) ) && # (State = State) = No Progress
		( $iteration <= $maxIterations ) &&
		( $error != 1 )	)	{
	
		$update = 0;
		&solvePuzzle;
		$iteration += 1;
	
	}

}

sub solvePuzzle {
	
	# Log
	print ("\n" x 0); &outputPuzzleHeader;

	# Log  (TSV)
	print ("\n" x 2); &outputPuzzleTSV;

	# Puzzle
	&setRequiredValues;	# WRITES to @Cells
	&{RegexPM::setRegexes}(\@cells);
	&getPermutations;
	
	# Log	
	print ("\n" x 2); &outputRegexes;
	
	# Puzzle
	&{IntersectionsPM::setIntersections}(\@permutations);	# WRITES to @permutations
	&setColumnSummaries;	# WRITES to @Cells

	# Log (TSV)
	print ("\n" x 1); &outputPuzzleTSV;
	
	# State
	&saveState;

}

# END






# SECTION: FUNCTIONS

sub getPossible {

# 	UNDERSTANDING THE FUNCTION
#
#	Accept a cell index; If the exact cell value isn't known, assume it's value is the range [1..9];
#	Get the known values of the row, col, and box for this cell, remove them from range, and set the
#	value of the cell.
# 	
# 	Cells "see" the previously set possible values of neighbor cells,ie [1|7|8],
# 	and try: $possible[178] = undef. When @possible is converted to the return string,
#	the undef values at those high index aren't included. I prevent this and the needless 
#	expansion of the @possible array by not undef'ing values > 9.

	my ($cellIndex, $rowIndex, $colIndex, $boxIndex);
	
	$cellIndex = shift;
	
	( $rowIndex, $colIndex, $boxIndex ) = @{ $indiciesByCellIndex[ $cellIndex ] };

	my @possible = (1,2,3,4,5,6,7,8,9);

	# Iterate over the row, col, and box for this cellIndex
	foreach my $num ((	getIndex($rowIndex), getIndex($colIndex), getIndex($boxIndex)	)) {  # $num is a cellIndex from the list, not zero-based
	
		$value = $cells[$num -1];
		if ( ($value =~ /\d/) && ($value < 10) ) { $possible[$value - 1] = undef; }
		
	}

# 	print Dumper \@possible;

	return join "", @possible;

}

sub getColumnSummary {

	my (@list) = @_;

	my @charPercent = ( # One Box
		[0,0,0,0,0,0,0,0,0],# 1st Char
		[0,0,0,0,0,0,0,0,0],# 2nd Char
		[0,0,0,0,0,0,0,0,0],# ... 
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0]	
	);
	
	foreach my $line ( @list ) {
		my @chars = split //,$line;
		
		foreach my $i ( 0 .. 8 ) {
			my $pos = $chars[$i] - 1;
			$charPercent[$i][ $pos ] += 1;
		}
		
	}
	
	return \@charPercent; # Ref (Scalar)
}

sub getPermutations {
	
	foreach $i ( 0 .. $#regexes ) {
	
		if ( scalar @{$permutations[$i]} == 0 ) {
			
			@{$permutations[$i]} = grep { /$regexes[$i]/; } @file_list;

		} else {

			@{$permutations[$i]} = grep { /$regexes[$i]/; } @{$permutations[$i]};
		
		}
		
		my $permutationsCount = scalar @{ $permutations[$i] };

		if ( $permutationsCount == 0 ) {
			# Move this into an errors hash that can be dealt with before each iteration.
			print "\nError (No Permutations): No permutations for regex $i (0-based)\n$regexes[$i]\n\n";
			&outputPuzzleTSV;
			exit;
		}
		
	}
	
}

sub getKnownCount {
	
	# $puzzle is global
	$puzzle = join "\t", @cells;
	
	my @unknowns = ($puzzle =~ /\.|\d\d+/g);
	
	return 81 - (scalar @unknowns);
}

sub getIndex {
	# Perl in a nutshell ... 
	my $index = shift @_;
	return @{$indicies[$index]}; # Return a list (separate vars, all at same level); Stores in array.
}

sub setDotCellValues {

	# Get the possible values for the unknown cells.
	foreach $i ( 0 .. 80 ) {

		$cells[$i] = &getPossible($i) if ( $cells[$i] =~ /\./ );

	}

}

sub setRequiredValues {

	# Loop every row,col,box
	foreach my $i ( 0 .. 26 ) {
	
		my @cellList = @{$indicies[$i]};
		
		my @cellListValues = ( 
			$cells[ $cellList[0] -1 ], 
			$cells[ $cellList[1] -1 ], 
			$cells[ $cellList[2] -1 ], 
			$cells[ $cellList[3] -1 ],
			$cells[ $cellList[4] -1 ], 
			$cells[ $cellList[5] -1 ], 
			$cells[ $cellList[6] -1 ], 
			$cells[ $cellList[7] -1 ],			 
			$cells[ $cellList[8] -1 ] 
		);
		
		$values = join "|", @cellListValues;
	
		
		@countedValues = ( 0,0,0,0,0,0,0,0,0 );
		
		foreach $valueIndex ( 0 .. 8 ) { # 9-digit iterator for both cellList (indexes) and cellListValues (values)
		
			$value = $cellListValues[$valueIndex]; # Current cell value
			
			if ( length $value > 1 ) { # True? Current cell value is more than 1 digit long; False? The value is already known, skip
				
				foreach $digit ( split //, $value ) { # Get the digits of the cell value one by one
				
					if ( $countedValues[$digit -1] == 0 ) { # Cache check; Don't check the same digit if it occurs in multiple cells within a row|col|box.
						
						my @m = ( $values =~ /${digit}/g ); # Check to see how many times this digit occurs
						my $numMatches = scalar @m;
						
						if ( $numMatches  == 1 ) {  	# True? Current cell value is now known; It's the only cell to provide the required digit for the row|col|box @{$indicies[$i]}.
										# Example: Cell value 789 becomes 7.
								
							$update = 1;		
							$cells[ $cellList[$valueIndex] -1 ] = ${digit}; # WRITE Cell
							
							# LOG
							print "\nList $i — $values\n";
							print "Digit $digit found once; Changing cells[".($cellList[$valueIndex] -1)."]=$value to value $digit. Knowns: ".&getKnownCount." | setRequiredValues\n";							
							
						}
						
						$countedValues[$digit - 1] = $numMatches; # Update cache for this digit.
						
					}
					
				}
						
			}
			
		}

	}

}

sub setColumnSummaries {

	foreach my $i ( 0 .. 26 ) {
		&setColumnSummary( $i, &getColumnSummary( @{$permutations[$i]} ), $indicies[$i], scalar @{$permutations[$i]} );	# WRITES to @Cells
	}

}

sub setColumnSummary {
	
	# 	UNDERSTANDING THE ARGUMENTS TO THIS FUNCTION
	# 
	# 	getColumnSummary(@row|col|box) READS a list of permutations for any supplied row|col|box, and returns a list of column summaries called @charPercent
	# 	setColumnSummary examines @charPercent and WRITES the column summaries to their respective cells, if they're known (non-regex) values.
	# 
	# 	getColumnSummary receives a list of permutations for a row, col, or box. An example list is below:
	# 
	# 	913 524 867
	# 	914 253 687
	# 	914 253 867
	# 
	#	"charPercent" is an array of sub-arrays, each of which is a "columnSummary" for the list of permutations.
	#
	# 	@charPercent = ( [0,0,0,0,0,0,0,0,3], [3,0,0,0,0,0,0,0,0], [0,0,1,2,0,0,0,0,0], ..., [0,0,0,0,0,0,3,0,0] )  
	# 	
	#	So ... 
	#
	# 	@columnSummary = [0,0,0,0,0,0,0,0,3] # Summary for column 1: Column 1 must be a 9, because 9 shows up all 3 times. So $indicies[0] = 9;
	# 	@columnSummary = [3,0,0,0,0,0,0,0,0] # Summary for column 2: Column 2 must be a 1, because 1 shows up all 3 times. So $indicies[1] = 1;
	# 	@columnSummary = [0,0,1,2,0,0,0,0,0] # Summary for column 3: Both 3 and 4 show up in this column. We don't know what the value is yet.
	#
	# 	... and so on, summarizing the character columns of the permutation list ... 
	#
	# 	@columnSummary = [0,0,0,0,0,0,3,0,0] # Summary for column 9: Column 9 must be a 7, because 7 shows up all 3 times. So $indicies[8] = 7;
	#
	# 
	#	Writing the values ...
	#
	# 	Column 1: WRITE $indicies[0] = 9.
	# 	Column 2: WRITE $indicies[1] = 1.
	# 	Column 3: Both 3 and 4 show up. $indicies[2] = 34, so don't update it 
	#
	#	And so on ... for all columns.
	
	#	------------------------------
	
	# 	WARNING (Getting the arguments into the function):
	#
	#	( $charPercent, $indicies, $totalPermutations ) is a LIST of the top level of @_
	#
	# 	$charPercent is a scalar REF to a LIST of scalar REF to LISTS
	#	$indicies is a REF to a LIST of scalars
	#	$totalPercent is an scalar (a 'plain integer')

	my ($listNo, $charPercent, $indicies, $totalPermutations) = @_;
	my @charPercent = @{$charPercent}; # Deref LIST; Now array of scalar REFs to LISTS
	my @indicies = @{$indicies}; # Deref LIST; Now array of scalars 
	
	for my $i ( 0 .. 8 ) { # Indicies is always a 9-place array of cell indexes corresponding to a row, col or box.

		my $cellIndex = $indicies[$i] - 1; # Examples: $cellIndex = 1 is the 1st cell in the 81-cell puzzle. @indicies(1,2,3,10,11,13,19,20,21) = Column 1 of the 81-square puzzle.
		my @columnSummary = @{$charPercent[ $i ]};
		
		my $write = 0;
		my $possible = "";
		
		for my $ii ( 0 .. 8 ) { # Each index in @columnSummary
			if ( $columnSummary[$ii] > 0 ) { $possible .= ("" . ($ii + 1)) }
			if ( ($columnSummary[$ii] == $totalPermutations) && ( $cells[$cellIndex] != ($ii+1) ) ) {
				
				$update = 1;
				$write = 1;
				$cells[$cellIndex] = $ii + 1; # Set the cell to the digit when the digit occurs in every permutation.
				
				# LOG
				print "\nList $listNo — Setting cells[".($cellIndex)."]=".($ii + 1)." Knowns: ".&getKnownCount." | setColumnSummary\n";
				
			}
		}
		
		# The column summary produced a regex. If it's "better" than existing regex, update it.
		if ( (! $write) && ( $cells[$cellIndex] > $possible ) ) {
			$cells[$cellIndex] = $possible;
		}
		
	}
	
}

sub saveState {
	push @state, join "\t", @cells; # TSV
}

sub checkConform {

	# For a row, col, or box ... 
	# Returns: [sum of knowns, list of unknowns]

	@items = &getIndex(shift @_); # expects zero-based index: Row 7 is Index 6.

	my $sum = 0;
	my @need = (1,2,3,4,5,6,7,8,9);

	foreach $item (@items) {
		my $value = $cells[$item -1];
		if ( ($value =~ /\d/) && ($value < 10) ) {
			$need[$value -1] = undef;
			$sum += $value;
		}
	}

	my @need = grep { $_ } @need;

	# Perl in a nutshell ... 
# 	return ($sum, @need); # Return a list (separate vars, all at same level); Stores in an array
# 	return [$sum, @need]; # Return a scalar ref to array, all at same level
	return [$sum, \@need]; # Return a scalar ref to array [ int, [] ] 

}

sub outputRegexes {

	my @labels = qw(
	
		Row_1	Row_2	Row_3	Row_4	Row_5	Row_6	Row_7	Row_8	Row_9
		Col_1	Col_2	Col_3	Col_4	Col_5	Col_6	Col_7	Col_8	Col_9
		Box_1	Box_2	Box_3	Box_4	Box_5	Box_6	Box_7	Box_8	Box_9
	
	);
	
	foreach $i ( 0 .. $#regexes ) {
		
		print "$i\t$labels[$i] (" .( scalar @{$permutations[$i]} ). ")\t$regexes[$i]\n";

		if ( ($i > 0) && ($i != $#regexes) && ($i % 9) == 8 ) { print "\n"; }
		
	}

}

sub outputPermutations {

	my $columnSummariesOn = shift @_;
	
	my @labels = qw(
	
		Row_1	Row_2	Row_3	Row_4	Row_5	Row_6	Row_7	Row_8	Row_9
		Col_1	Col_2	Col_3	Col_4	Col_5	Col_6	Col_7	Col_8	Col_9
		Box_1	Box_2	Box_3	Box_4	Box_5	Box_6	Box_7	Box_8	Box_9
	
	);
	
	my $total_permutations = 0;
	
	print( ("\n" x 1), 'outputPermutations label (count) - [sum, needed]', ("\n" x 1) );
	
	foreach my $i ( 0 .. 26 ) { # 27 Permutation Lists
		
		my $conform = &checkConform($i);

		print(
			("\n" x 1),
			"$i: [\t// $labels[$i] ("  .  ( scalar @{$permutations[$i]} )  .  ") - [@{$conform}[0], "  .  (( join "", @{@{$conform}[1]} ) || "-")  .  "]\n\t",
			( join ", ", @{$permutations[$i]} ),
			("\n" x 1),
			"]", 
			( ($i < 26) ? "," : "" ) # Comma?
		);

		
		if ($columnSummariesOn) {
			
			print ("\n" x 2);
			
			my @cellSummaries = @{ &getColumnSummary( @{$permutations[$i]} ) };
		
			print "Cell\t";
			print join "\t", map { $_ - 1 } @{ $indicies[$i] }; # 0-base cell indexes
			print "\n";
			
			foreach $r1 ( 0 .. 8 ) {
				print "\n" . ($r1 + 1);
				foreach $r2 ( 0 .. 8 ) {
					print "\t".$cellSummaries[$r2][$r1];
				}
			}
		
			print "\n";		
		}
		

		$total_permutations += scalar @{$permutations[$i]};
		
	}
	
	print( 
		("\n" x 2),
		'Total Permutations: ', $total_permutations,
		("\n" x 2)
	);

}

sub outputPuzzleTSV {

	print "TSV (" .&getKnownCount. ") —— " . 's/(\d\d+)/\./g' . "\n";

	foreach $i (0 .. 80) {
		print $cells[$i];
		if  ( (($i + 1) > 0) && (($i + 1) % 9 == 0) ) {
			print "\n";
		} else {
			print "\t";
		}
	}
	
	return "";	
}

sub outputPuzzleHeader {
	print( 
		("\n" x 2),
		('=' x 50),
		("\n" x 1),		
		'Puzzle Iteration (', $iteration, ')',
		("\n" x 1),
		('=' x 50),
		("\n" x 1)
	);
}