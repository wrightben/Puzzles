package WrightPM; 
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
our @EXPORT = qw( ); # Export by default
our @EXPORT_OK = qw( ); # Export on request




# BEGIN MODULE

sub moduleTest {
	print(
		"Hello, world.\n",
		"Seeing this? ... Comment out &moduleTest; in WrightPM.pm",
		("\n" x 1)
	);
	return 0;
}

# &moduleTest; # This code is executed when module is loaded by the line: use lib::WrightPM;

1;