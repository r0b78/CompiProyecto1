rm lex.yy.c
rm proyecto1Parser.tab.h
rm proyecto1Parser.tab.c
rm a.out
bison -d proyecto1Parser.y
flex proyecto1Scanner.l
gcc lex.yy.c proyecto1Parser.tab.c -lfl
