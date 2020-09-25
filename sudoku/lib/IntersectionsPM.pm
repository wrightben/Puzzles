package IntersectionsPM; 
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
our @EXPORT_OK = qw( setIntersections ); # Export on request ( ? )

my ($package, $filename, $line) = caller;


# BEGIN MODULE

# ABOUT THE MODULE:
# This module accepts a list of arrays (permutations for each row, col, and box) and
# filters the arrays for each intersection of box-row or box-col

# Globals
@boxSegments = (

	[0,1,2], # Row1
	[3,4,5], # Row2
	[6,7,8], # Row3
	# ---- ^^ ----
	[0,3,6], # Col1
	[1,4,7], # Col2
	[2,5,8]  # Col3
	
);
$boxRow1 = $boxSegments[0]; 
$boxRow2 = $boxSegments[1];
$boxRow3 = $boxSegments[2];
$boxCol1 = $boxSegments[3];
$boxCol2 = $boxSegments[4];
$boxCol3 = $boxSegments[5];


# @permutations: "Real" global with "Dummy" data
@permutations = (
	[	# Row_1 (2) - [26, 289]
		"934586721", "834526791", "321654798" # TEST
	],
	[	# Row_2 (8) - [18, 134568]
		"825917463", "528917463", "125987463", "625917843", "526917843", "125947863", "625917834", "526917834"
	],
	[	# Row_3 (9) - [15, 124689]
		"967143825", "967413825", "967813425", "967183425", "867123945", "867123495", "817423965", "167423895", "617423895"
	],
	[	# Row_4 (4) - [31, 158]
		"245891376", "248195376", "245198376", "241895376"
	],
	[	# Row_5 (6) - [22, 4568]
		"596738142", "695738142", "698735142", "896735142", "698734152", "896734152"
	],
	[	# Row_6 (4) - [26, 1459]
		"371462958", "371462598", "375162948", "375162498"
	],
	[	# Row_7 (1) - [45, -]
		"482359617"
	],
	[	# Row_8 (6) - [17, 134569]
		"653271489", "163274589", "613274589", "659271483", "169274583", "619274583"
	],
	[	# Row_9 (10) - [15, 134589]
		"759618243", "759681243", "713684259", "713648259", "759618234", "759681234", "719684253", "719648253", "753618249", "753681249"
	],
	[	# Col_1 (8) - [16, 15689]
		"958263417", "956283417", "986253417", "968253417", "951283467", "918253467", "981253467", "819253467"
	],
	[	# Col_2 (3) - [33, 156]
		"321497865", "326497815", "326497851"
	],
	[	# Col_3 (12) - [13, 135689]
		"467581239", "467851239", "487165239", "467185239", "457861239", "487561239", "467581293", "467851293", "487165293", "467185293", "457861293", "487561293"
	],
	[	# Col_4 (3) - [32, 148]
		"591874326", "598174326", "594871326"
	],
	[	# Col_5 (6) - [30, 1248]
		"284936571", "248936571", "842936571", "812936574", "281936574", "241936578"
	],
	[	# Col_6 (6) - [27, 1458]
		"673852914", "673582914", "673852941", "673582941", "673542918", "673152948"
	],
	[	# Col_7 (4) - [19, 4589]
		"789314652", "748319652", "784319652", "789315642"
	],
	[	# Col_8 (8) - [16, 234569]
		"236749185", "236759184", "269745183", "962745183", "269754183", "962754183", "246759183", "264759183"
	],
	[	# Col_9 (3) - [29, 349]
		"145628739", "135628794", "145628793"
	],
	[	# Box_1 (8) - [16, 15689]
		"934526817", "934125867", "934825167", "834125967", "934825617", "934625817", "934528167", "934528617", "123456789" # TEST
	],
	[	# Box_2 (6) - [30, 1248]
		"526947813", "526987143", "526947183", "586917423", "526987413", "586947123"
	],
	[	# Box_3 (7) - [13, 234689]
		"721834965", "721843965", "721863945", "721463895", "721863495", "791463825", "791863425"
	],
	[	# Box_4 (6) - [25, 1568]
		"245698371", "248695371", "241896375", "241698375", "248596371", "245896371"
	],
	[	# Box_5 (4) - [27, 1458]
		"198735462", "195738462", "891735462", "895734162"
	],
	[	# Box_6 (4) - [27, 459]
		"376142958", "376152948", "376152498", "376142598"
	],
	[	# Box_7 (6) - [21, 13569]
		"482163759", "482613759", "482653719", "482169753", "482619753", "482659713", "123456789" # TEST
	],
	[	# Box_8 (4) - [32, 148]
		"359271684", "359274681", "359271648", "359274618"
	],
	[	# Box_9 (5) - [24, 3459]
		"617483259", "617583249", "617589234", "617489253", "617589243"
	]
);


# TESTING
if ( ! $package ) {
	&setIntersections;
}



# SUBROUTINES FOR INTERSECTIONS
# Requires @permutations

sub setIntersections {

	my ($ref0) = shift @_ || \@permutations;
	@permutations = @{$ref0}; # Setting local-global variable, if necessary;
	

	# Iterate over the 18 combinations of Box-Row, Box-Col intersections.
	# [ index, index, segment, segment ]; index is the key value for @permutations (which corresponds to @indicies)
	my @params = (
		# Row-Box
		[  0, 18, [0,1,2], $boxRow1 ],
		[  0, 19, [3,4,5], $boxRow1 ],
		[  0, 20, [6,7,8], $boxRow1 ],
		[  1, 18, [0,1,2], $boxRow2 ],
		[  1, 19, [3,4,5], $boxRow2 ],
		[  1, 20, [6,7,8], $boxRow2 ],
		[  2, 18, [0,1,2], $boxRow3 ],
		[  2, 19, [3,4,5], $boxRow3 ],
		[  2, 20, [6,7,8], $boxRow3 ],

		[  3, 21, [0,1,2], $boxRow1 ],
		[  3, 22, [3,4,5], $boxRow1 ],
		[  3, 23, [6,7,8], $boxRow1 ],
		[  4, 21, [0,1,2], $boxRow2 ],
		[  4, 22, [3,4,5], $boxRow2 ],
		[  4, 23, [6,7,8], $boxRow2 ],
		[  5, 21, [0,1,2], $boxRow3 ],
		[  5, 22, [3,4,5], $boxRow3 ],
		[  5, 23, [6,7,8], $boxRow3 ],

		[  6, 24, [0,1,2], $boxRow1 ],
		[  6, 25, [3,4,5], $boxRow1 ],
		[  6, 26, [6,7,8], $boxRow1 ],
		[  7, 24, [0,1,2], $boxRow2 ],
		[  7, 25, [3,4,5], $boxRow2 ],
		[  7, 26, [6,7,8], $boxRow2 ],
		[  8, 24, [0,1,2], $boxRow3 ],
		[  8, 25, [3,4,5], $boxRow3 ],
		[  8, 26, [6,7,8], $boxRow3 ],
		
		# Col-Box
		[  9, 18, [0,1,2], $boxCol1 ],
		[  9, 21, [3,4,5], $boxCol1 ],
		[  9, 24, [6,7,8], $boxCol1 ],
		[ 10, 18, [0,1,2], $boxCol2 ],
		[ 10, 21, [3,4,5], $boxCol2 ],
		[ 10, 24, [6,7,8], $boxCol2 ], 
		[ 11, 18, [0,1,2], $boxCol3 ],
		[ 11, 21, [3,4,5], $boxCol3 ],
		[ 11, 24, [6,7,8], $boxCol3 ], 

		[ 12, 19, [0,1,2], $boxCol1 ],
		[ 12, 22, [3,4,5], $boxCol1 ],
		[ 12, 25, [6,7,8], $boxCol1 ], 
		[ 13, 19, [0,1,2], $boxCol2 ],
		[ 13, 22, [3,4,5], $boxCol2 ],
		[ 13, 25, [6,7,8], $boxCol2 ], 
		[ 14, 19, [0,1,2], $boxCol3 ],
		[ 14, 22, [3,4,5], $boxCol3 ],
		[ 14, 25, [6,7,8], $boxCol3 ], 	

		[ 15, 20, [0,1,2], $boxCol1 ],
		[ 15, 23, [3,4,5], $boxCol1 ],
		[ 15, 26, [6,7,8], $boxCol1 ],
		[ 16, 20, [0,1,2], $boxCol2 ],
		[ 16, 23, [3,4,5], $boxCol2 ],
		[ 16, 26, [6,7,8], $boxCol2 ],
		[ 17, 20, [0,1,2], $boxCol3 ],
		[ 17, 23, [3,4,5], $boxCol3 ], 
		[ 17, 26, [6,7,8], $boxCol3 ]

	);
	


	for my $i ( 0 .. $#params ) {
	
		@a	= &getPermutationSegmentKeys( $params[$i][1], $params[$i][3] );
		@b	= &getPermutationSegmentKeys( $params[$i][0], $params[$i][2] );

		%intersection = &getIntersection(\@a, \@b);
		
		&setIntersection(\%intersection, $params[$i][0], $params[$i][1], $params[$i][2], $params[$i][3], $i );	
	}
	
	# Set the global | pseudo-global variable
	@{ "${package}::permutations" } = @permutations;

	return @permutations;

}

sub setIntersection {

	my ($hash, $index1, $index2, $seg1, $seg2, $no) = @_;
	
	my %intersection = %{$hash};

	# Segment Elements
	my @s1 = @{$seg1};
	my @s2 = @{$seg2};

	# Filtered Lists
	my @arr1_filtered = ();
	my @arr2_filtered = ();
	
	my @keys = keys %intersection;

	foreach $key (@keys) {
		if ( length $intersection{$key} > 1 ) {

			@digits = split //, $key;
			@mask1 = ('\d','\d','\d','\d','\d','\d','\d','\d','\d');
			@mask2 = ('\d','\d','\d','\d','\d','\d','\d','\d','\d');

			$mask1[$s1[0]] = $digits[0];
			$mask1[$s1[1]] = $digits[1];
			$mask1[$s1[2]] = $digits[2];

			$mask2[$s2[0]] = $digits[0];
			$mask2[$s2[1]] = $digits[1];
			$mask2[$s2[2]] = $digits[2];

			$mask1_filter = join "", @mask1;
			$mask2_filter = join "", @mask2;
			
			push @arr1_filtered, grep { $_ =~ /$mask1_filter/ } @{$permutations[$index1]}; 
			push @arr2_filtered, grep { $_ =~ /$mask2_filter/ } @{$permutations[$index2]}; 
		
		}
	}
	
	# Logging
	$scal1 = scalar @{$permutations[$index1]};
	$scal1f = scalar @arr1_filtered;
	$scal2 = scalar @{$permutations[$index2]};
	$scal2f = scalar @arr2_filtered;
	
	
	if ( ( $scal1 != $scal1f ) || ( $scal2 != $scal2f ) ) {
		print "\nFiltered intersection $no; ( $scal1, $scal1f ), ( $scal2, $scal2f )\n";

		${ "${package}::update" } = 1;
		
	}
	
	
	# Clear, Reset permutations arrays to filtered lists
	@{$permutations[$index1]} = ();
	@{$permutations[$index1]} = @arr1_filtered;
	
	@{$permutations[$index2]} = ();
	@{$permutations[$index2]} = @arr2_filtered;
	

}

sub getPermutationSegmentKeys {

	# accepts a permutation list, creates list of unique 3-number segment strings
	# example: @( @("123456789", "456123789", "456789123"), [6,7,8] ) = @( 789, 123 )

	my ($ref0, $ref1) = @_;

	my @permutationList = @{$permutations[ $ref0 ]};
	my ($a,$b,$c) = @{ $ref1 };

	my %segments;
	foreach $p ( @permutationList ) {
		my @s = split //, $p;
		$segments{"$s[$a]$s[$b]$s[$c]"} = 1;
	}
	
	return sort (keys %segments);

}

sub getIntersection {

	# accepts multiple lists (\d{3}, \d+, or \w+) created by getPermutationSegmentKeys, 
	# returns a hash identifying which list values are shared and/or unique
	#
	# example: @( @(5,8), @(3,5) ) =  %{3:"2", 5:"2,1", 8:"1"} 
	# example explained: Digit 5 is in both lists "2,1", 3 is in list "2", 8 is list "1".

	my %hashKeys;

	my $i = 1;
	foreach $ref (@_) {
		foreach $item ( @{$ref} ) {
			if ( ($hashKeys{$item} != undef) && ($hashKeys{$item} != $i) ) { $hashKeys{$item} .= ","; }
			$hashKeys{$item} .= $i;
		}
		$i ++;
	}
	
	# DEBUG
# 	print Dumper \%hashKeys;
	
	return %hashKeys;
			
}

# END


1;