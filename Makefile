COMPILE = g++

scanner: lex.yy.c
	$(COMPILE) $< -o $@

lex.yy.c: cmos.l
	lex $<

clean:
	rm scanner *.txt