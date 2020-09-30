#!/usr/bin/perl


@list = qw(

2356	1346	1245
2689	1679	1278
3589	3479	4578

);

chomp @list;

$regex = "";
foreach $item (@list) {
	@chars = split //, $item;
	$chars = join '|',@chars;
	$regex .= '['. $chars .']';
}

print $regex;