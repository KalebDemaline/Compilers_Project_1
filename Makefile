COMPILE = g++ -std=c++11

cmos: cmos.cpp
	$(COMPILE) $< -o $@+

scanner: lex.yy.c
	$(COMPILE) $< -o $@

lex.yy.c: cmos.l
	lex $<

clean:
	-@ rm -f lex.yy.c scanner *.txt *+