#!/usr/bin/perl

use Data::Dumper;

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


&histogram;

sub histogram {

	my (@need, @histogram, $unknownCount, @strings);

	@need = (9,9,9,9,9,9,9,9,9);
	@histogram = ( [], [], [], [], [], [], [], [], [] );
	$unknownCount = 0;

	foreach $i ( 0 .. $#cells ) {
		my $cell = $cells[$i];
		if ( $cell =~ /\d\d+/ ) {
			$unknownCount += 1;
			@digits = split //, $cell;
			foreach $digit ( @digits ) {
				push @{$histogram[$digit - 1]}, $i;
			}
		} elsif ( $cell =~ /^\d$/ ){
			$need[$cell -1] -= 1;
		}
	}

	# @strings
	foreach $item (@histogram) {
		push @strings, "[ " . ( join ",", @{$item} ) . " ]\n"; # Concat output
	}

	
	print (
		("\n" x 2),
		"Histogram\n",
		( join "", @strings),
		("\n" x 1),
		"Unknown Count: $unknownCount"
	);

	print( 
		("\n" x 1),
		"Need Count\n",
		( join ", ", @need)
	);

}