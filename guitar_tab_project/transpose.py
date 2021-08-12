#transpose set of pitches to lowest limit and then create octave transpositions for available octaves

def trans(direction, octaves, notes):
	"""
	transpose string of notes in a given direction
	direction = "up" or "down"
	notes = string of notes	
	"""
	#use recursion for octaves
	if octaves == 0:
		notes = notes.rstrip(" ")
		return notes
	notes = notes.rstrip(" ")
	notes = notes.split(" ")
	transposition = ""
	if direction == "up":
		#transpose up
		for note in notes:
			if note[-1] == ",":
				transposition += note[:-1] + " "
			else:
				transposition += note + "' "
	elif direction == "down":
		#transpose down
		for note in notes:
			if note[-1] == "'":
				transposition += note[:-1] + " "
			else:
				transposition += note + ", "
	return trans(direction, octaves -1, transposition)


def all_trans(notes):
	"""
	produces all transpositions of string of notes
	"""
	up = ["8va", "15va"]
	down = ["8vb", "15vb"]
	all_trans = []
	for octave in up:
		all_trans.append((trans("up", up.index(octave) + 1, notes), octave))
		print(all_trans)
	for octave in down:
		all_trans.append((trans("down", down.index(octave) + 1, notes), octave))
		print(all_trans)
	return all_trans