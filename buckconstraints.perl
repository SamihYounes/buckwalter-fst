#!/usr/bin/perl

my @data1, @data2, @data3;

open(DATA1, "original/tableAB") || die "Can't open $file: $!\n";
open(DATA2, "original/tableBC") || die "Can't open $file: $!\n";
open(DATA3, "original/tableAC") || die "Can't open $file: $!\n";

foreach $argnum (0 .. $#ARGV) {
    if ($ARGV[$argnum] =~ '\-n') { $lineanalysis = 1;    } # Whether to put strings or line numbers in analyses
}

@linesAB = <DATA1>;
@linesBC = <DATA2>;
@linesAC = <DATA3>;

push (@linesABBC, @linesAB);
push (@linesABBC, @linesBC);


foreach (@linesABBC) {
    chomp;
    if ($_ =~ /^;/) {
	next;
    }
    if ($_ =~ /^$/) {
	next;
    }
    @elem = split ' ';
    
    $lhs = $elem[0];
    $rhs = $elem[1];
#    print "pushing to [$lhs], [$rhs]\n";
    $CONSTR{$lhs} .= "\"[" .$rhs ."]\"|";
}

print "### RULES AB and BC###\n\n";
$i = 1;

foreach $lhs (sort keys %CONSTR) {
    $CONSTR{$lhs} =~ s/\|$//g;
    print "define Rule$i [\"[$lhs]\" => _ ?*  [$CONSTR{$lhs}]] ;\n";
    $i++;
}


foreach (@linesAC) {
    chomp;
    if ($_ =~ /^;/) {
	next;
    }
    if ($_ =~ /^$/) {
	next;
    }
    @elem = split ' ';
    
    $lhs = $elem[0];
    $rhs = $elem[1];
#    print "pushing to [$lhs], [$rhs]\n";
    $CONSTR2{$lhs} .= "\"[" .$rhs ."]\"|";
}

print "\n\n### RULES AC ###\n\n";
foreach $lhs (sort keys %CONSTR2) {
    $CONSTR2{$lhs} =~ s/\|$//g;
    print "define Rule$i [\"[$lhs]\" => _ ?*  [$CONSTR2{$lhs}]] ;\n";
    $i++;
}

print "define Lexicon Lexicon.i;\n";
for ($j = 1 ; $j < $i; $j += 10) {
    print "define Lexicon Lexicon .o. [";
    @rul = ();
    for ($k = $j ; $k < $i and $k < $j+10; $k++) {
	push (@rul, "Rule$k");
    }
    print join ' .o. ', @rul;
    print "] ;\n";
}

print "define Lexicon Lexicon.i; \n\n";
close(DATA1); close(DATA2); close(DATA3);
