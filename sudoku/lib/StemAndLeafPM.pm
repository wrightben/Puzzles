package StemAndLeafPM; 
# ^ This line creates the namespace for the symbols (subroutines, etc) in this file; Delete it to include all symbols in MAIN (global) namespace
# This module's "package" line ( package WrightPM ) does not have to match the "use" line ( use lib::WrightPM ) added to files that need this module.
# The package line is the namespace; The use line is the path to the module. 
# Example:
#	package WrightPM;	(in lib/WrightPM.pm)
#	use lib::WrightPM;	(in SomeOtherFile.pl)

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
our @EXPORT_OK = qw( ); # Export on request ( ? )




# BEGIN MODULE

@indexToBox = (	
	1,1,1, 2,2,2, 3,3,3,
	1,1,1, 2,2,2, 3,3,3,
	1,1,1, 2,2,2, 3,3,3,

	4,4,4, 5,5,5, 6,6,6,
	4,4,4, 5,5,5, 6,6,6,
	4,4,4, 5,5,5, 6,6,6,

	7,7,7, 8,8,8, 9,9,9,
	7,7,7, 8,8,8, 9,9,9,
	7,7,7, 8,8,8, 9,9,9
);

# %h-stored-local
%h = (
	1 => [ 9,13,18,19,21,22,29,30,32,47,48,63,64,68,73,76,77 ],
	2 => [ 4,7,22,25 ],
	3 => [ 16,17,65,71,74,79,80 ],
	4 => [ 13,15,16,17,21,22,24,25,41,43,48,51,52,68,69,76,77,79,80 ],
	5 => [ 9,11,29,32,36,38,41,43,47,51,52,64,69,73,79 ],
	6 => [ 9,11,16,18,19,25,36,38,63,64 ],
	7 => [  ],
	8 => [ 0,4,9,11,13,15,18,21,22,24,29,30,32,36,38,41,76,77 ],
	9 => [ 0,7,18,24,25,51,52,65,71,74,80 ]
);

%digits;




# &outputStemAndLeaf({ 1 => [ 9, 13, 18] }); # %h-as-parameter
# &outputStemAndLeaf; # Local


# SUBROUTINES FOR RegexStemLeaf
# Requires @cells

sub getRegexStemLeaf {

	my ($ref0) = @_; # Reference to @Cells
	
	@cells = @{ $ref0 };

	my (@need, @regexStemLeaf, $unknownCount);

	@need = (9,9,9,9,9,9,9,9,9);
	@regexStemLeaf = ( [], [], [], [], [], [], [], [], [] );
	$unknownCount = 0;

	foreach $i ( 0 .. $#cells ) {
		my $cell = $cells[$i];
		if ( $cell =~ /\d\d+/ ) {
			$unknownCount += 1;
			@digits = split //, $cell;
			foreach $digit ( @digits ) {
				push @{$regexStemLeaf[$digit - 1]}, $i;
			}
		} elsif ( $cell =~ /^\d$/ ){
			$need[$cell -1] -= 1;
		}
	}


	my (@strings, $inc, %h);
	$inc = 0;
	foreach $item (@regexStemLeaf) {
		push @strings, "[ " . ( join ",", @{$item} ) . " ]\n"; # Concat output
		$h{++ $inc} = \@{$item};
	}

	
	print (
		("\n" x 2),
		"Regex Stem-Leaf\n",
		"Outputs a hash of { digit => [cellIndexAvailable] .. }",
		("\n" x 2),
		( join "", @strings),
		("\n" x 1),
		"Unknown Count: $unknownCount"
	);

	print( 
		("\n" x 1),
		"Need Count (# of each digit required to finish puzzle)",
		("\n" x 1),
		( join ", ", @need),
		("\n" x 2),
		"Outputs a hash of { digit (the actual digit 1-9) => { digit (box available 1-9 ) => [ cellIndexAvailable ] }}",
		("\n" x 1),		
		"digit-box [indexes]",
		("\n" x 1)
	);

	&outputStemAndLeaf(\%h);

}


sub outputStemAndLeaf {

	$ref = (shift @_ || \%h); # Scalar $ref to (%h-as-parameter) || (%h-stored-local)
	
	%h = %{$ref};
	
	%digits = &doWork;
	
	foreach my $label (sort keys %digits) {

		foreach my $key ( sort keys %{$digits{$label}} ) {
			&makeOutput(
				"$label-$key [",
				( join ", ", @{ $digits{$label}{$key} } ),
				"]"
			);
		}

	}
	
}


sub doWork {
	my %digits;
	for $i ( 1 .. 9 ) {
		my @a = @{$h{$i}};
		if (scalar @a > 0) {
			my %temp;
			foreach $a (@a) {
				if ( $temp{ $indexToBox[$a] } == undef ) {
					$temp{ $indexToBox[$a] } = [];
				}
				push @{ $temp{ $indexToBox[$a] } }, $a;
			}
			$digits{$i} = \%temp;
		}
	}
	return %digits;
}


$inc = 0;
sub makeOutput {
	print(
		++ $inc,
		": ",
		(join " ",
			@_
		),
		("\n" x 1)
	);
}

# END

1;