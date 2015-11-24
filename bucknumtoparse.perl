#!/usr/bin/perl

my @data1, @data2, @data3;

open(DATA1, "original/dictPrefixes") || die "Can't open $file: $!\n";
open(DATA2, "original/dictStems") || die "Can't open $file: $!\n";
open(DATA3, "original/dictSuffixes") || die "Can't open $file: $!\n";

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

    for ($i = 0; $i < 4; $i++) {
	if ($line[$i] eq '') {
	    $line[$i] = "0";
	}
    }
    $surfaceuv = $line[0];
    $surfacev  = $line[1];
    $class     = $line[2];
    $gloss    = $line[3];


    $lineno2 = "$lineno";
    $lineno2 =~ s/0/%0/g;

    $p .= "P%:$lineno2:PREFIXUV%:[$surfaceuv]% PREFIXV%:[$surfacev]% PREFIXCLASS%:[$class]% PREFIXGLOSS:[$gloss]%  Stems;\n";
}

$p .= "\nLEXICON Stems\n\n";

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

    for ($i = 0; $i < 4; $i++) {
	if ($line[$i] eq '') {
	    $line[$i] = "0";
	}
    }
    $surfaceuv = $line[0];
    $surfacev  = $line[1];
    $class     = $line[2];
    $gloss     = $line[3];

    # We skip lines that are identical for the last three fields, for example:

    # >wkAlbtws    >uwkAlibotuws        N   eucalyptus
    # AwkAlbtws    >uwkAlibotuws        N   eucalyptus

    if ($duplicate{"$surfacev/$class/$gloss"} == 1) {
	next;
    } else {
	$duplicate{"$surfacev/$class/$gloss"} = 1;
    }

    if ($gloss eq '') {
	$gloss = "0";
    }
    $lineno2 = "$lineno";
    $lineno2 =~ s/0/%0/g;
    $p .= "S%:$lineno2:STEMUV%:[$surfaceuv]% STEMV%:[$surfacev]% STEMCLASS%:[$class]% STEMGLOSS:[$gloss]%  Suffixes;\n";
}

$p .= "\nLEXICON Suffixes\n\n";

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
    for ($i = 0; $i < 4; $i++) {
	if ($line[$i] eq '') {
	    $line[$i] = "0";
	}
    }
    $surfaceuv = $line[0];
    $surfacev  = $line[1];
    $class     = $line[2];
    $gloss    = $line[3];

    if ($gloss eq '') {
	$gloss = "0";
    }
    push (@multichars, "[$class]");
    $lineno2 = "$lineno";
    $lineno2 =~ s/0/%0/g;
    $p .= "X%:$lineno2:SUFFIXUV%:[$surfaceuv]% SUFFIXV%:[$surfacev]% SUFFIXCLASS%:[$class]% SUFFIXGLOSS:[$gloss]%  #;\n";
}
print "Multichar_Symbols PREFIXUV%: PREFIXV%: PREFIXCLASS%: PREFIXGLOSS%: STEMUV%: STEMV%: STEMCLASS%: STEMGLOSS%: SUFFIXUV%: SUFFIXV%: SUFFIXCLASS%: SUFFIXGLOSS%: %<pos%> %<%/pos%>\n\n";

print $p;

close(DATA1); close(DATA2); close(DATA3);

sub uniq_array {
    %seen = ( );
    return(grep { ! $seen{$_} ++ } @_);
}
