COMPILE = g++

scanner: lex.yy.c
	$(COMPILE) $< -o $@

lex.yy.c: cmos.l
	lex $<

clean:
	-@ rm -f lex.yy.c scanner *.txt