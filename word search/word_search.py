import math

puzzle = "fibbgnrxbxzfucioepflcabpkrceiyxnelnwltobbxduohkgmqecmnvqaabmulmdbctkjuixhwzsnnysukrrejzeljzrmvkljcgdhuzmtgniripsnijracellfpitsycisweetrgykgyxopreyzdeowwftjucdftdleolrrzrpynehobudqwitunayronqudueteyvoflsmasxyphomacfilihulylgifbejvlttptrbegazfnvptannquzrndaqrcanmrcqtrasifpsntthtkvzdeweiaoijuhrhzobrxwbumtwhnjgpglifgwsyljsmbgroxldhvxnhldehlhhcolorfuloqtofpirskrkssqlbtolhejspaodjsvorugekaaisialidgaykmiioizzxorcfvihqvrvoweiafnubnekeliqmrxmgbwtblugwdsqrirfhdordlxacmucbkcfxolunwglierionvaeeqvjixeczvfvljunnslplrkjkalsyoaedheeiofspaakcgoloocdczmzmhvffdgicehhazyxkitxjupuqjdygtnfosjxspwzcbwfghgbywwlylevolkugxbtbcfngefyzzsupajaqvm"
puzzleAsList = list( puzzle )
puzzleLength = len( puzzle )
puzzleSize = int(math.sqrt( puzzleLength ))
puzzleIndex = {
	'a' : [ ], 'b' : [ ], 'c' : [ ], 'd' : [ ], 'e' : [ ], 'f' : [ ], 'g' : [ ], 'h' : [ ], 'i' : [ ], 
	'j' : [ ], 'k' : [ ], 'l' : [ ], 'm' : [ ], 'n' : [ ], 'o' : [ ], 'p' : [ ], 'q' : [ ], 'r' : [ ], 
	's' : [ ], 't' : [ ], 'u' : [ ], 'v' : [ ], 'w' : [ ], 'x' : [ ], 'y' : [ ], 'z' : [ ]
}

# INDEX letters of the puzzle
i = 0
for l in puzzleAsList:
	puzzleIndex[l].append( i )
	i += 1


# FUNCTIONS
def getIndex(r,c,s):
	return ( (r-1) * s ) + c - 1

def getCol(i,s):
	return math.ceil( abs(i) % s ) + 1

def getRow(i,s):
	return math.ceil( (abs(i) + 1) / s )
	
def up(i,w,s):
	wl = len(w)

	# e-tests
	e = i - (s * (wl - 1))
	if e < 0: return 0
	if puzzle[e] != w[-1]: return 0
	_up = list(puzzle[x] for x in range(i,e-s,-s) )
	
	if list(w) == _up: return 1
	
	return 0

def down(i,w,s):
	wl = len(w)
	
	# e-tests
	e = i + (s * (wl - 1))
	if e >= puzzleLength: return 0
	if puzzle[e] != w[-1]: return 0

	_down = list(puzzle[x] for x in range(i,e+s,s) )
	if list(w) == _down: return 1
	
	return 0

def right(i,w,s):
	wl = len(w)
	r = getRow(i,s)
	
	# e-tests
	e = i + (wl - 1)
	if r != getRow(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_right = list(puzzle[x] for x in range(i,e+1,1) )
	if list(w) == _right: return 1
	
	return 0
	
def left(i,w,s):
	wl = len(w)
	r = getRow(i,s)
	
	# e-tests
	e = i - (wl - 1)
	if r != getRow(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_left = list(puzzle[x] for x in range(i, e-1, -1) )
	if list(w) == _left: return 1
	
	return 0	

def upright(i,w,s):
	wl = len(w)
	c = getCol(i,s)
	ss = s-1
	
	# e-tests
	e = i - (ss * (wl - 1))
	if e < 0: return 0
	if c > getCol(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_upright = list(puzzle[x] for x in range(i,e-ss,-ss) )
	
	if list(w) == _upright: return 1	
	
	return 0

def downright(i,w,s):
	wl = len(w)
	c = getCol(i,s)
	ss = s+1
	
	# e-tests
	e = i + (ss * (wl - 1))
	if e > puzzleLength: return 0
	if c > getCol(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_upright = list(puzzle[x] for x in range(i,e+ss,ss) )
	
	if list(w) == _upright: return 1	
	
	return 0

def upleft(i,w,s):
	wl = len(w)
	c = getCol(i,s)
	ss = s+1
	
	# e-tests
	e = i - (ss * (wl - 1))
	if e < 0: return 0
	if c < getCol(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_upleft = list(puzzle[x] for x in range(i,e-ss,-ss) )
	
	if list(w) == _upleft: return 1	
	
	return 0
	
def downleft(i,w,s):
	wl = len(w)
	c = getCol(i,s)
	ss = s-1
	
	# e-tests
	e = i + (ss * (wl - 1))
	if e >= puzzleLength: return 0
	if c < getCol(e,s): return 0
	if puzzle[e] != w[-1]: return 0
	
	_downleft = list(puzzle[x] for x in range(i,e+ss,+ss) )
	
	if list(w) == _downleft: return 1	
	
	return 0	


# Words and Search

words = [ # 24
	"beautiful",
	"bright",
	"brilliant",
	"brisk",
	"chilly",
	"clear",
	"cold",
	"colorful",
	"cool",
	"dew",
	"early",
	"extraordinary",
	"fine",
	"fresh",
	"glorious",
	"golden",
	"hazy",
	"inspiring",
	"lovely",
	"soft",
	"splendid",
	"sunny",
	"sweet",
	"warm"
]


for word in words:
	for i in puzzleIndex[ word[0] ]:
# 		Clockwise: 
# 			1. up
# 			2. up right
# 			3. right
# 			4. down right
# 			5. down
#			etc ..
		print( 	word, i, ': ', 
			up(i, word, puzzleSize),
			upright(i, word, puzzleSize),
			right(i, word, puzzleSize),
			downright(i, word, puzzleSize),
			down(i, word, puzzleSize),
			downleft(i, word, puzzleSize),
			left(i, word, puzzleSize),
			upleft(i, word, puzzleSize)						
		)