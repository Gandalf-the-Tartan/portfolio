from instrument_models import *

def fret(notes, low):
    notes = notes.split(" ")
    "takes string of pitches and returns string of pitches and fret numbers"
    matching_notes = 0
    current_string = 6
    tab = ""
    high = low + 3
    for note in notes:
        for string in GUITAR:
            if note in string and in_range(string.index(note), low, high): 
                tab += ("{}\\{} ".format(note, current_string))
                matching_notes += 1
            current_string -=1
        current_string = 6
    if matching_notes == len(notes):
        return tab
    else:
        return ""

def in_range(fret, lowest_fret, max_fret):
    #returns Boolean for whether fret is between two other frets
    #print("lowest_fret: {} <= fret: {} <= max_fret: {} returns: {}".format(lowest_fret, fret, max_fret, (lowest_fret <= fret <= max_fret)))
    return lowest_fret <= fret <= max_fret