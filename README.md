#Summary
This project performs an automatic conversion of the original Buckwalter Arabic Morphological Analyzer (BAMA) files into a finite-state transducer parser which is intended to be equivalent to the original Perl code.

The original Buckwalter files are needed for conversion (GPL version included in tarball). The scripts produce two transducers, which map Arabic input words in Buckwalter encoding to their parses + glosses.

How to compile
In the main directory, run make.

This requires that you have

perl installed
foma installed (including flookup from the foma package for parsing)
Compilation produces a file buckwalter-num.foma which contains two transducers in foma format required for parsing.

How to parse words
Run

flookup buckwalter-num.foma
This reads words from stdin and prints parses to stdout. This method gives the full parse (classes and glosses). If you only want to parse a single word, you can, for example, do:

echo "ktb" | flookup buckwalter-num.foma
Which should produce an output of 9 possible parses like:

#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[katab] STEMCLASS:[PV] STEMGLOSS:[write] SUFFIXUV:[] SUFFIXV:[a] SUFFIXCLASS:[PVSuff-a] SUFFIXGLOSS:[he/it <verb> <pos>+a/PVSUFF_SUBJ:3MS</pos>] 

#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[] SUFFIXCLASS:[Suff-0] SUFFIXGLOSS:[] 

#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[i] SUFFIXCLASS:[NSuff-i] SUFFIXGLOSS:[[def.gen.] <pos>+i/CASE_DEF_GEN</pos>] 
#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[u] SUFFIXCLASS:[NSuff-u] SUFFIXGLOSS:[[def.nom.] <pos>+u/CASE_DEF_NOM</pos>] 
#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[N] SUFFIXCLASS:[NSuff-N] SUFFIXGLOSS:[[indef.nom.] <pos>+N/CASE_INDEF_NOM</pos>] 

#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[a] SUFFIXCLASS:[NSuff-a] SUFFIXGLOSS:[[def.acc.] <pos>+a/CASE_DEF_ACC</pos>] 
#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutub] STEMCLASS:[N] STEMGLOSS:[books] SUFFIXUV:[] SUFFIXV:[K] SUFFIXCLASS:[NSuff-K] SUFFIXGLOSS:[[indef.gen.] <pos>+K/CASE_INDEF_GEN</pos>] 

#PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[kutib] STEMCLASS:[PV_Pass] STEMGLOSS:[be written;be fated;be destined] SUFFIXUV:[] SUFFIXV:[a] SUFFIXCLASS:[PVSuff-a] SUFFIXGLOSS:[he/it <verb> <pos>+a/PVSUFF_SUBJ:3MS</pos>]

Here, both the unvocalized and vocalized prefixes, stems, and suffixes are listed for each entry, together with class and gloss information.

Implementation details
The resulting file buckwalter-num.foma in actuality contains two transducers which are applied in a sequence by flookup to perform parsing. The first transducer maps input words in Buckwalter encoding to the line numbers at which each prefix, stem, and suffix is located in the original BAMA prefix, stem, and suffix files, e.g.

ktb
P:34S:102687X:34
The second transducer maps this intermediate form into the complete parse and gloss:

P:34S:102687X:34
PREFIXUV:[] PREFIXV:[] PREFIXCLASS:[Pref-0] PREFIXGLOSS:[] STEMUV:[ktb] STEMV:[katab] STEMCLASS:[PV] STEMGLOSS:[write] SUFFIXUV:[] SUFFIXV:[a] SUFFIXCLASS:[PVSuff-a] SUFFIXGLOSS:[he/it <verb> <pos>+a/PVSUFF_SUBJ:3MS</pos>]
It is of course possible to compose the two transducers to yield a single transducer that performs the mapping in one step, at the cost of a larger transducer. Flookup does this chaining at runtime, so we can save some space by leaving the two transducers separate.

References
Buckwalter, T. (2004). Arabic Morphological Analyzer 2.0. Linguistics Data Consortium (LDC).

Hulden, M. and Samih, Y. (2012). Conversion of procedural morphologies to finite-state morphologies: a case study of Arabic. In Proceedings of FSMNLP 2012.
