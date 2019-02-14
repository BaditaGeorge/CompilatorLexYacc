%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
%}
%%
"principal()" { return MAIN; }
"{" { return START; }
"}" { return END; }
"intreg"|"real"|"car"|"sircar" { yylval = strdup(yytext); return TIP;}
"if" { return IF; }
"cat_timp" { return WHILE; }
"pentru" { return FOR; }
"else" { return ELSE;}
"band" { yylval=strdup(yytext); return CLASS; }
"privat:"|"public:"|"protected:" { yylval=strdup(yytext); return PROP;}
"++" { return INCR;}
"--" { return DECR;}
maxim { return MAX; }
minim { return MIN; }
modul { return MOD; }
cmmdc { return CMMDC; }
cmmmc { return CMMMC; }
"Print" { yylval=strdup(yytext); return PRINT;}
"const" { return CONST; }
"<"|">"|"<="|">="|"=="|"!=" { yylval=strdup(yytext); return COMP;}
"=" { yylval=strdup(yytext); return ASSIGN; }
"AND" { return AND; }
"OR" { return OR; }
[_'a-zA-Z][_'a-zA-Z0-9]* { yylval = strdup(yytext); return ID; }
"-"?[1-9][0-9]* { yylval=strdup(yytext); return NR;}
[\t]+ ;
[' ']+ ;
"\r\n"|"\n" { yylineno++; }
. { return yytext[0]; }
%%
