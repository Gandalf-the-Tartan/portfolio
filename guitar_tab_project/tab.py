import os
from fret import *
from transpose import *

def guitar_tab_file(infile, outfile, low):
    """
    takes file containing strings of pitches
    returns lilypond file and compiled pdf
    'outfile' is string of filename, e.g. foo.ly
    'low' is an integer representing the low fret
    'infile' is input file 
    """
    #create lilypond file
    f = open(outfile, "w")
    #version infomation
    f.write("\\version \"2.18.2\"\n")
    #write regular notes then tab notes
    f.write("{\n  ")
    for line in read_piece(infile):
        f.write(fret(line.rstrip("\n"), low) + "\n")
    f.write("}\n")
    f.write("\\new TabStaff {\n  ")
    for line in read_piece(infile):
        f.write(fret(line.rstrip("\n"), low) + "\n")
    f.write("}")
    f.close()
    #compile lilypond file then remove
    os.system("lilypond {}".format(outfile))
    #os.system("rm {}".format(outfile))

def guitar_tab_notes(notes, outfile):
    """
    takes string of pitches
    returns lilypond file and compiled pdf
    'outfile' is string of filename, e.g. foo.ly
    'notes' is a string of notes 
    """
    #create lilypond file
    f = open(outfile, "w")
    #version infomation
    f.write("\\version \"2.18.2\"\n")
    #write regular notes then tab notes
    f.write("{\n  ")
    f.write(notes)
    f.write("}\n")
    #write tab for all transpositions within fret range
    transpositions = all_trans(notes)
    for current_fret in range(GUITAR_FRET_LIMIT):
        if fret(notes, current_fret) == "":
                continue
        else:
            f.write("\\markup {\n  fret:" + str(current_fret) + " unison\n}\n\n")
            f.write("\\new TabStaff {\n  ")
            f.write(fret(notes, current_fret))
            f.write("}\n")
            
        for transposition in transpositions:
            if fret(transposition[0], current_fret) == "":
                continue
            else:
                f.write("\\markup {\n  fret:" + str(current_fret) + " " + transposition[1] + "\n}\n\n")
                f.write("\\new TabStaff {\n  ")
                f.write(fret(transposition[0], current_fret))
                f.write("}\n")
                
    f.close()
    #compile lilypond file then remove
    os.system("lilypond {}".format(outfile))
    #os.system("rm {}".format(outfile))

def read_piece(infile):
    """
    reads notes from files
    returns an array strings
    """
    f = open(infile, "r")
    piece = f.readlines()
    f.close()
    return piece
