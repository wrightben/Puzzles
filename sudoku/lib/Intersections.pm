package lib::Intersections;
 
use Exporter qw(import);
 
our @EXPORT_OK = qw(
	setIntersections
	setIntersection
	getPermutationSegmentKeys
	getIntersection
	outputPermutationLengths
);

# SUBROUTINES FOR INTERSECTIONS

sub setIntersections {

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
		$update = 1;
	}
	
	
	# Clear, Reset permutations arrays to filtered lists
	@{$permutations[$index1]} = ();
	@{$permutations[$index1]} = @arr1_filtered;
	
	@{$permutations[$index2]} = ();
	@{$permutations[$index2]} = @arr2_filtered;
	

}

sub getPermutationSegmentKeys {

	# accepts a permutation list, creates list of unique 3-number segment strings
	# example: @( @(123456789, 456123789, 456789123), [6,7,8] ) = @( 789, 123 )

	my @permutationList = @{$permutations[@_[0]]};
	my ($a,$b,$c) = @{ @_[1] };

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

sub outputPermutationLengths {
	foreach my $i (0 .. $#permutations) {
		$scalar = scalar @{ $permutations[$i] };
	
		print "$i ($scalar)";
		print "\n";
	}
}

# END
 
1;