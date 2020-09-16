#!/usr/bin/perl

use Data::Dumper;


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


@permutations = ( );


# LOG Permutations
&outputPermutationLengths;

&setIntersections;

#LOG Permutations
print ("\n" x 2);
&outputPermutationLengths;
# print Dumper \@permutations;




# SUBROUTINES FOR INTERSECTIONS

