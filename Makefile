all: buckwalter-num.foma

buckwalter-num.foma: bucklexc.perl buckconstraints.perl buckwalter-num.lexc buckwalter-num.script buckwalter-constraints.script
	foma -f buckwalter-num.script

buckwalter-num.lexc: bucklexc.perl
	perl -C bucklexc.perl -n > buckwalter-num.lexc
	perl -C bucknumtoparse.perl > buckwalter-numtotext.lexc

buckwalter-constraints.script: buckconstraints.perl
	perl -C buckconstraints.perl > buckwalter-constraints.script
