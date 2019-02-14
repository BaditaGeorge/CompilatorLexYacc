all:
lex limbaj.l
yacc -d limbaj4.y
gcc lex.yy.c y.tab.c -ly -ll -w
