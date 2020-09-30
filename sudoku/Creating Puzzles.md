## Creating Puzzles

1-based boxes [1..9]

* From @file_list, select int( rand[0..362_881] )
* Fill Box 1
* setCellDotValues

* Create regex for Box 2
* Fill Box 2 ( from list of permutations for Box 2 )
* setCellDotValues

* Create regex for Box 3
* Fill Box 3 ( from list of permutations for Box 3 )
* setCellDotValues

* Create regex for Box 4
* Fill Box 4 ( from list of permutations for Box 4 )
* setCellDotValues

* Create regex for Box 7
* Fill Box 7 ( from list of permutations for Box 7 )
* setCellDotValues

* Create regex for Box 9
* Fill Box 9 ( from list of permutations for Box 9 )
* setCellDotValues

* Use solver.pl to begin solving the puzzle, selecting guesses, if necessary, from the remaining boxes of permutations.

* Remove 5-7 numbers from each box, confirming that the puzzle is solvable after every each digit is removed. 