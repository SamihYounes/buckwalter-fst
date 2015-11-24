#!/usr/bin/perl

my @data1, @data2, @data3;

foreach $argnum (0 .. $#ARGV) {
    if ($ARGV[$argnum] =~ '\-n') { $lineanalysis = 1;    } # Whether to put strings or line numbers in analyses
}

open(DATA1, "original/dictPrefixes") || die "Can't open $file: $!\n";
open(DATA2, "original/dictStems") || die "Can't open $file: $!\n";
open(DATA3, "original/dictSuffixes") || die "Can't open $file: $!\n";

open(DATA4, ">buckwalter-classes.script") || die "Can't open $file: $!\n";

@lines1 = <DATA1>;
@lines2 = <DATA2>;
@lines3 = <DATA3>;


$p  = "LEXICON Root\n\nPrefixes ;\n\n";
$p .= "LEXICON Prefixes\n\n";

$lineno = 0;
foreach (@lines1) {
    $lineno++;
    chomp;

    if ($_ =~ /^;/) {
	next;
    }
    if ($_ =~ /^$/) {
	next;
    }

    $_ =~ s/ +/ /g;                         # Compress spaces
    $_ =~ s/([ 0<>;!:?"])/%\1/g;            # Escape for lexc
    if ($_ =~ /(%<pos%>.*?%<\/pos%>)/) {
	push (@multichars2, $1);
    }
    @line = split '\t';

    $surface = $line[1];
    $class = $line[2];
    $gloss = $line[3];

    if ($surface eq '') {
	$surface = "0";
    }
    push (@multichars, "[$class]");

    if ($lineanalysis == 1) {
	$lineno2 = "$lineno";
	$lineno2 =~ s/0/%0/g;
	$p .= "[" .$class ."]" ."{" ."P%:$lineno2" ."}" .":$surface  Stems;\n"; 
    } else {
	$p .= "[" .$class ."]" ."{" .$gloss ."}" .":$surface  Stems;\n";
    }
}

$p .= "LEXICON Stems\n\n";

$lineno = 0;
foreach (@lines2) {
    $lineno++;
    chomp;

    if ($_ =~ /^;;/) {
	$_ =~ s/^;;//g;
	$_ =~ s/ +//g;
	$_ =~ s/([ 0<>;!:?"])/%\1/g;
	$lemma = $_;
	next;
    }
    if ($_ =~ /^;/) {
	next;
    }
    if ($_ =~ /^$/) {
	next;
    }
    $_ =~ s/ +/ /g;
    $_ =~ s/([ 0<>;!:?"])/%\1/g;

    if ($_ =~ /(%<pos%>.*?%<\/pos%>)/) {
	push (@multichars2, $1);
    }

    @line = split '\t';

    $surface = $line[1];
    $class = $line[2];
    $gloss = $line[3];

    # We skip lines that are identical for the last three fields, for example:

    # >wkAlbtws    >uwkAlibotuws        N   eucalyptus
    # AwkAlbtws    >uwkAlibotuws        N   eucalyptus

    if ($duplicate{"$surface/$class/$gloss"} == 1) {
	next;
    } else {
	$duplicate{"$surface/$class/$gloss"} = 1;
    }



    if ($surface eq '') {
	$surface = "0";
    }
    push (@multichars, "[$class]");
    if ($lineanalysis == 1) {
	$lineno2 = "$lineno";
	$lineno2 =~ s/0/%0/g;
	$p .= "[" .$class ."]" ."{" ."S%:$lineno2" ."}" .":$surface  Suffixes;\n";
    } else {
      # $p .= "[" .$class ."]" ."{" .$gloss ."}" .":$surface  Suffixes;\n";
	$p .= "[" .$class ."]($lemma)" ."{" .$gloss ."}" .":$surface  Suffixes;\n";
    }
}

$p .= "LEXICON Suffixes\n\n";

$lineno = 0;
foreach (@lines3) {
    $lineno++;
    chomp;
    if ($_ =~ /^;/) {
	next;
    }
    if ($_ =~ /^$/) {
	next;
    }

    $_ =~ s/ +/ /g;
    $_ =~ s/([ 0<>;!:?"])/%\1/g;

    if ($_ =~ /(%<pos%>.*?%<\/pos%>)/) {
	push (@multichars2, $1);
    }

    @line = split '\t';

    $surface = $line[1];
    $class = $line[2];
    $gloss = $line[3];


    if ($surface eq '') {
	$surface = "0";
    }
    push (@multichars, "[$class]");
    if ($lineanalysis == 1) {
	$lineno2 = "$lineno";
	$lineno2 =~ s/0/%0/g;
	$p .= "[" .$class ."]" ."{" ."X%:$lineno2" ."}" .":$surface  #;\n";
    } else {
	$p .= "[" .$class ."]" ."{" .$gloss ."}" .":$surface  #;\n";
    }
}

#print "Multichar_Symbols %<pos%> %</pos%> CONJ+ PREP+ EMPHATIC_PARTICLE+ RESULT_CLAUSE_PARTICLE+ DET+ IV3MS+ IV3MD+ IV3MP+ IV3FP+ SUBJUNC+ IV3FS+ [masc.sg.] [fem.du.] [fem.sg.] [fem.pl.] [masc.pl.] IV2MS+ FUT+ IV2D+ IV3FD+ IV2FS+ IV2MP+ IV2FP+ IV3FS+ IV1S+ IV1P+ ADJ NOUN ADV INTERJ VERB_IMPERFECT VERB_PERFECT VERB_PART VERB_IMPERATIVE PVSUFF_SUBJ 3MS 3FS 3FD 2MS 2MD 1S 1P PRON_3FS PRON_3MS PRON_3FP PRON_3MP PRON_2MS PRON_2MP PRON_2FS PRON_2FP PRON_1S PRON_1P CVSUFF_SUBJ PVSUFF_SUBJ PVSUFF_DO CASE_DEF_NOM CASE_DEF_ACC CASE_DEF_GEN NSUFF_FEM_DU_ACCGEN NSUFF_FEM_DU_NOM NSUFF_FEM_DU_NOM_POSS POSS_PRON_3MS POSS_PRON_3D POSS_PRON_3MP POSS_PRON_3FS POSS_PRON_2MS POSS_PRON_2FS POSS_PRON_2D POSS_PRON_2MP POSS_PRON_1S POSS_PRON_1P NSUFF_FEM_DU_ACCGEN_POSS NSUFF_MASC_DU_ACCGEN NSUFF_MASC_DU_ACCGEN_POSS NSUFF_MASC_SG_ACC_INDEF " ;
print "Multichar_Symbols ";

@m2 = uniq_array(@multichars);
@m3 = uniq_array(@multichars2);
print join(' ', @m2) ." ";
#print join(' ', @m3);

foreach (@m2) {
    $_ =~ s/%//g;
    push (@m4, "\"" .$_ ."\"");
}

print DATA4 "define Classes [";
print DATA4 join('|', @m4);
print DATA4 "];\n\n";


print "\n\n";

print $p;

close(DATA1); close(DATA2); close(DATA3);

sub uniq_array {
    %seen = ( );
    return(grep { ! $seen{$_} ++ } @_);
}
