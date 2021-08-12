#instrument fretboards modelled as dictionaries

#maximum fret on a guitar string
GUITAR_FRET_LIMIT = 19
string_1 = ["e'", "f'", "fis'", "g'", "gis'","a'", 
"ais'", "bis'", "c''", "cis''","d''", "dis''", "e''", "f''","fis''", "g''", "gis''", "a''", "ais''","b''"]
string_2 = ["b", "c'", "cis'", "d'", "dis'",
"e'", "f'", "fis'", "g'", "gis'","a'", "ais'", "bis'", "c''", "cis''","d''", "dis''", "e''", "f''","fis''"]
string_3 = ["g", "gis", "a", "ais","b", "c'", "cis'", "d'", "dis'",
"e'", "f'", "fis'", "g'", "gis'","a'", "ais'", "bis'", "c''", "cis''","d''"]
string_4 = ["d","dis", "e", "f","fis", "g", "gis", "a", "ais","b", "c'",
  "cis'", "d'", "dis'","e'", "f'", "fis'", "g'", "gis'","a'"]
string_5 = ["a,", "ais,", "b,", "c", "cis", "d",
 "dis", "e", "f","fis", "g", "gis", "a", "ais","b", "c'", "cis'", "d'", "dis'","e'"]
string_6 = ["e,", "f,", "fis,", "g,", "gis,", "a,", "ais,", "b,", "c", "cis", "d",
 "dis", "e", "f","fis", "g", "gis", "a", "ais","b"]
GUITAR = [string_6, string_5, string_4, string_3, string_2, string_1]
