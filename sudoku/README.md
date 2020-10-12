# Sudoku
solver.pl fully solves traditional sudoku puzzles in common books, like those published by PennyPress, etc.

Google search suggests several sudoku sites to me; They're nearly worthless. Their puzzles lack sufficient clues for full solutions, at least without guesses which would be nearly impossible for ordinary people. Still, solver.pl will partially solve those puzzles and provide guesses (box permutations) that fully solve them if any solutions exist.

Tip: If the solver gets "stuck" and requires a guess, just replace a dot with one of numbers from one of the suggested box permutations.

```
./solver.pl  > ~/Desktop/solution.txt 
```


## Summary

The file **permutations.txt** is the 9!-long list of permutations for 123456789, and **solver.pl** requires it to solve a puzzle.

```
$time ./solver.pl  > ~/Desktop/solution.txt 

real	0m4.322s
```


#### Numbers to TSV.numbers
Use *Numbers to TSV.numbers* to "Copy Puzzle" from Sudoku.com, then copy-paste to **solver.pl**.

```
.	.	4	.	.	6	.	.	1
.	2	.	9	.	7	.	.	.
.	.	.	.	.	3	.	.	5
.	.	.	.	.	.	3	.	6
.	9	.	7	.	.	1	.	.
3	7	.	.	.	.	.	.	8
4	.	.	.	5	.	.	.	.
.	.	.	2	.	.	.	8	.
7	.	.	6	.	.	2	.	.

# Glitch Warning: Missing .?
```

#### solution.txt
- The puzzle in .tsv with the possible numbers for each cell.
- The regular expressions and permutations available for each box.
- The steps .sovler.pl takes toward finding a solution

#### How the program solves a puzzle
* Unique Required: A particular digit appears as part of just 1 regex. That cell must equal the digit.
* Column Summary: A particular digit always appears in a column of permutations. That column must equal that digit.
* Intersections of permutations between row-col, or box-col, filter permutations that are not connectors. The intersections are implicitly box-row-col.
* (Not implemented) State + Guessing: Substituting permutations in breadth-first may force a solution to the puzzle when permutations have been reduced

#### Calculating a list of permutations manually (for any 1 box, row, or col)

The **./permutations** folder includes **regex_builder.pl** and **unique_filter.pl**, which print a list of the available permutations for any row, col, or box copied-pasted from the Numbers file. It's a manual operation, which requires a copy-paste from *Numbers to TSV.numbers* into **regex_builder.pl**.

```
cat permutations.txt | grep -e "$(./permutations/regex_builder.pl)" | ./permutations/unique_filter.pl
```

Modify the permutations for copy-paste into the .numbers file (regex below):
```
# Before
123456789;

# After
1	2	3
4	5	6
7	8	9
```


```
s/([\d])([\d])([\d])([\d])([\d])([\d])([\d])([\d])([\d]);[\t]?/\1\t\2\t\3\n\4\t\5\t\6\n\7\t\8\t\9\n\n/;
```