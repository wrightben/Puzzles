# Sudoku
solver.pl fully solves sudoku puzzles in PennyPress books. Other puzzles, like some found in Puzzlewright Press books, require guessing. solver.pl will partially solve those puzzles and provide guesses that fully solve them if a solution exists. If solver.pl gets "stuck" and requires a guess, just replace a dot with a corresponding digit from one of the suggested box permutations.

```
$time ./solver.pl  > ~/Desktop/solution.txt 

real	0m4.322s
```


## Summary

The file **permutations.txt** is the 9!-long list of permutations for 123456789, and **solver.pl** requires it to solve a puzzle.




#### Numbers to TSV.numbers
Use *Numbers to TSV.numbers* to "Copy Puzzle", then copy-paste to **solver.pl**.

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

# Tip: Copy-paste sometimes excludes dots and causes problems.
```

#### solution.txt
- The puzzle in .tsv with the possible numbers for each cell.
- The regular expressions and permutations available for each box.
- The steps .solver.pl takes toward finding a solution

#### How the program solves a puzzle
* Unique Required: A particular digit appears as part of just 1 regex. That cell must equal the digit.
* Column Summary: A particular digit always appears in a column of permutations. That column must equal that digit.
* Intersections of permutations (box-row and box-col) filter extraneous permutations
* (Not implemented) State + Guessing: Substituting permutations in breadth-first may force a solution to the puzzle when permutations have been reduced
