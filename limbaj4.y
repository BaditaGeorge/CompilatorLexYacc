%{
#include <stdio.h>
#include <string.h>
#include "limbaj.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;	
%}
%token MAIN START END TIP IF WHILE FOR ELSE CLASS PROP INCR DECR MAX MIN MOD CMMDC CMMMC CONST PRINT COMP ASSIGN ID NR AND OR
%start progr
%%
progr: clase procedee centric { printf("Program corect sintactic!\n"); Functions3($1);};
	| procedee centric { printf("Program corect sintactic!\n"); };
	| centric { printf("Program corect sintactic!\n");};

declaratii: declaratii ',' declaratie ';' { char *s=malloc(strlen($1)+strlen($3)+10); strcpy(s,$1); strcat(s,","); strcat(s,$3); strcat(s,";"); $$=s;}
			| declaratii ',' declaratie { char *s=malloc(strlen($1)+strlen($3)+10); strcpy(s,$1); strcat(s,","); strcat(s,$3); $$=s;}
			| declaratii declaratii ';' { char* s=malloc(strlen($1)+strlen($2)+10); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); strcat(s,";"); $$=s;}
			| declaratie { char* s=malloc(strlen($1)+10); strcpy(s,$1); $$=s; }
			| declaratii declaratie ';' { char* s=malloc(strlen($1)+strlen($2)+10); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); strcat(s,";"); $$=s;}
			| /* empty */
			;
declaratie: TIP ID { char *s=malloc(strlen($1)+strlen($2)); strcpy(s,$1); strcat(s," "); strcat(s,$2); $$=s;Procesez($1,$2,"--","--");}
			| ID ID
			| TIP ID '[' NR ']' { char *s=malloc(strlen($1)+strlen($2)+strlen($4)+5); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,"["); strcat(s,$4); strcat(s,"]"); $$=s; } 
			| TIP ID ASSIGN NR { char *s=malloc(strlen($1)+strlen($2)+strlen($3)+strlen($4)+10); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,$3); strcat(s,$4); $$=s; Procesez($1,$2,$3,$4); }
			| TIP ID ASSIGN expresii 
			| TIP ID '[' NR ']' ASSIGN START numbers END  { char* s=malloc(strlen($1)+strlen($2)+strlen($4)+strlen($8)+6); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,"["); strcat(s,$4); strcat(s,"]"); strcat(s,"="); strcat(s,"{"); strcat(s,$8); strcat(s,"}"); $$=s;}
			| /* empty */
			|
			;
clase: clasa ';' { $$=$1; }
		| clase clasa ';' { char *s=malloc(strlen($1)+strlen($2)+5); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); $$=s; }
		| /* empty */
		;
controale: control { $$=$1; }
		| controale control { char *s=malloc(strlen($1)+strlen($2)+10); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); $$=s;}
		| /* empty */
		;
control: WHILE '(' expresii ')' ';'  { char *s=malloc(strlen($1)+strlen($3)+5); strcpy(s,"cat_timp"); strcat(s,"("); strcat(s,$3); strcat(s,")"); $$=s;}
		| WHILE '(' expresii ')' START declaratii END { char *s=malloc(strlen($1)+strlen($3)+strlen($6)+10); strcpy(s,"cat_timp"); strcat(s,"("); strcat(s,$3); strcat(s,")"); strcat(s,"\n"); strcat(s,$6); $$=s; }
		| WHILE '(' expresii ')' START END { char *s=malloc(strlen($1)+strlen($3)+5); strcpy(s,"cat_timp"); strcat(s,"("); strcat(s,$3); strcat(s,")"); $$=s; }
		| FOR '(' ';' ';' ')' START declaratii END { char *s=malloc(strlen($1)+10); strcpy(s,"pentru"); strcat(s,"( ; ; )"); $$=s;}
		| FOR '(' ';' ';' ')' START END { char *s=malloc(strlen($1)+5); strcpy(s,$1); strcat(s,"( ; ; )");}
		| FOR '(' expresii ';' expresii ';' expresii ')' START declaratii END  { char *s=malloc(strlen($1)+strlen($3)+strlen($5)+strlen($7)+strlen($10)+5); strcpy(s,"pentru");
		strcat(s,"("); strcat(s,$3); strcat(s,";"); strcat(s,$5); strcat(s,";"); strcat(s,$7); strcat(s,")"); strcat(s,"\n"); strcat(s,$10); $$=s;}
		| FOR '(' expresii ';' expresii ';' expresii ')' START END { char *s=malloc(strlen($1)+strlen($3)+strlen($5)+strlen($7)); strcpy(s,"pentru"); strcat(s,"("); strcat(s,$3); strcat(s,";"); strcat(s,$5); strcat(s,";"); strcat(s,$7); strcat(s,")"); $$=s;}
		| FOR '(' expresii ';' expresii ';' expresii ')' ';' { char* s=malloc(strlen($1)+strlen($3)+strlen($5)+strlen($7)+5); strcpy(s,"pentru"); strcat(s,"("); strcat(s,$3); strcat(s,";"); strcat(s,$5); strcat(s,";"); strcat(s,$7); strcat(s,")");}
		| IF '(' expresii ')' START declaratii END { char* s=malloc(strlen($1)+strlen($3)+strlen($6)+5); strcpy(s,"daca"); strcat(s,"("); strcat(s,$3); strcat(s,")"); strcat(s,"\n"); strcat(s,$6); $$=s;}
		| ELSE IF '(' expresii ')' START declaratii END { char* s=malloc(strlen($1)+strlen($2)+strlen($4)+strlen($7)+5); strcpy(s,"else"); strcat(s,"if"); strcat(s,"("); strcat(s,$4); strcat(s,")"); strcat(s,"\n"); strcat(s,$7); }
		| ELSE START declaratii END { char *s=malloc(strlen($1)+strlen($3)+5); strcpy(s,"else"); strcat(s,"\n"); strcat(s,$3); $$=s;}
		| /* empty */
		;
clasa: CLASS ID START declaratii procedee END { char *s=malloc(strlen($1)+strlen($2)+strlen($4)+5); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,"\n"); strcat(s,$4); strcat(s,"\n"); strcat(s,$5); strcat(s,";"); strcat(s,"\n"); $$=s;}
		| CLASS ID START procedee END { char *s=malloc(strlen($1)+strlen($2)+strlen($4)+5); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,"\n"); strcat(s,$4); strcat(s,";"); strcat(s,"\n"); $$=s;}
		| CLASS ID START PROP END { char *s=malloc(strlen($1)+strlen($2)+strlen($4)+5); strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,"\n"); strcat(s,$4); strcat(s,";"); strcat(s,"\n"); $$=s; }
		| /* empty */
		;
numbers: NR { $$=$1; }
		| numbers ',' NR { char *s=malloc(strlen($1)+strlen($3)+5); strcpy(s,$1); strcat(s,","); strcat(s,$3); $$=s;}
		| /* empty */
		;
procedee: procedeu { $$=$1; }
		| procedee procedeu { char* s=malloc(strlen($1)+strlen($2)+5); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); $$=s;}
		| /* empty */
		;
centric: TIP MAIN START declaratii controale apele afisari END { printf("Principal\n"); char *s=malloc(strlen($1)+5); char *s2=malloc(strlen($2)+5); char *s3=malloc(strlen($4)+5); strcpy(s,$1); strcpy(s2,$2); strcpy(s3,$4); char *s4=malloc(strlen($5)+5); strcpy(s4,$5); char* s5=malloc(strlen($6)+5); strcpy(s5,$6); Functions2(s,s2," ",s3,s4,s5); }
		| TIP MAIN START END {}
		| TIP MAIN START declaratii END { }
		;
procedeu: TIP ID '(' ')' START declaratii controale END { char *s=malloc(strlen($1)+10); char *s2=malloc(strlen($2)+10); strcpy(s,$1); strcpy(s2,$2); char *s3=malloc(strlen($1)+strlen($2)+5); strcpy(s3,$1); strcat(s3," "); strcat(s3,$2); $$=s3; Functions(s,s2," ",$6);}
		| TIP ID '(' params ')' START declaratii controale END { char *s=malloc(strlen($1)+10); char *s2=malloc(strlen($2)+10); char *s3=malloc(strlen($3)+10); strcpy(s,$1); strcpy(s2,$2); strcpy(s3,$4); char *s4=malloc(strlen($1)+strlen($2)+5); strcpy(s4,$1); strcat(s4," "); strcat(s4,$2); $$=s4; Functions(s,s2,s3,$6);}
		| TIP ID '(' params ')' START declaratii controale expresii2 END { char *s=malloc(strlen($1)+10); char *s2=malloc(strlen($2)+10); char *s3=malloc(strlen($3)+10); strcpy(s,$1); strcpy(s2,$2); strcpy(s3,$4); char* s4=malloc(strlen($1)+strlen($2)+5); strcpy(s4,$1); strcat(s4," "); strcat(s4,$2); $$=s4; Functions(s,s2,s3,$6);}
		| TIP ID '(' ')' START declaratii controale expresii2 END {  char *s=malloc(strlen($1)+10); char *s2=malloc(strlen($2)+10); strcpy(s,$1); strcpy(s2,$2); char *s3=malloc(strlen($1)+strlen($2)+5); strcpy(s3,$1); strcat(s3," "); strcat(s3,$2); $$=s3; Functions(s,s2," ",$6); }
		| /* empty */
		;
params: params ',' param { char *s=malloc(strlen($1)+strlen($3)+10); strcpy(s,$1); strcat(s,","); strcat(s,$3); $$=s;}
		| /* empty */
		| param { char *s=malloc(strlen($1)+5); strcpy(s,$1); $$=s;}
		;
param: /* empty */
		| TIP ID { char *s=malloc(strlen($1)+strlen($2)+5); strcpy(s,$1); strcat(s," "); strcat(s,$2); $$=s;}
		| TIP ID ASSIGN NR { char *s=malloc(strlen($1)+strlen($2)+5); strcpy(s,$1); strcat(s, " "); strcat(s,$2); strcat(s,$3); strcat(s,$4); $$=s;}
		| TIP
		;
afisari: afisare
		| afisari afisare
		| /* empty */
		;
afisare: PRINT '(' expresii ',' TIP ')' ';' { Calcul($3); }
		| PRINT '(' ID ',' TIP ')' ';' { printf("%s\n", $3); }
		| PRINT '(' NR ',' TIP ')' ';' { printf("%s ( %s , %s )\n",$1,$3,$5); }
		| /* empty */
		;
paramsc: ID { $$=$1; }
		| NR { $$=$1; }
		| paramsc ',' ID { char* s=malloc(strlen($1)+strlen($3)+5); strcpy(s,$1); strcat(s,","); strcat(s,$3); $$=s; }
		| paramsc ',' NR { char* s=malloc(strlen($1)+strlen($3)+5); strcpy(s,$1); strcat(s,","); strcat(s,$3); $$=s; }
		| /* empty */
		;
apele: /* empty */
		| apeluri { $$=$1; }
		| apele apeluri { char* s=malloc(strlen($1)+strlen($2)+10); strcpy(s,$1); strcat(s,"\n"); strcat(s,$2); $$=s; }
		;
apeluri: /* empty */
		| ID '(' ')' ';' { char *s=malloc(strlen($1)+5); strcpy(s,$1); strcat(s,"("); strcat(s,")"); strcat(s,";"); Check2($1," "); $$=s;}
		| ID '(' paramsc ')' ';' { char *s=malloc(strlen($1)+strlen($3)+6); strcpy(s,$1); strcat(s,"("); strcat(s,$3); strcat(s,")"); strcat(s,";"); Check2($1,$3); $$=s; }
		| ID '.' ID '(' ')' ';' { char *s=malloc(strlen($1)+strlen($3)+5); strcpy(s,$1); strcat(s,"."); strcat(s,$3); strcat(s,"("); strcat(s,")"); strcat(s,";"); $$=s;}
		| ID '.' ID '(' paramsc ')' ';'  { char *s=malloc(strlen($1)+strlen($3)+strlen($5)); strcpy(s,$1); strcat(s,"."); strcat(s,$3); strcat(s,"("); strcat(s,$5); strcat(s,")"); strcat(s,";"); $$=s;}
		| ID '.' ID ';' { char* s=malloc(strlen($1)+strlen($3)+5); strcpy(s,$1); strcat(s,"."); strcat(s,$3); strcat(s,";"); $$=s;} 
		;
expresii2: expresii ';'
		| expresii2 expresii ';'
		;
expresii: ID { $$=$1; Check($1);}
		| NR { $$=$1; }
		| ID INCR { $$=$1; }
		| ID DECR { $$=$1; }
		| expresii COMP expresii { Check($1); char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,$2); strcat(s,$3); $$=s;}
		| expresii '+' expresii { char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"+"); strcat(s,$3); $$=s; }
		| expresii '-' expresii { char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"-"); strcat(s,$3); $$=s; }
		| expresii '*' expresii { char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"*"); strcat(s,$3); $$=s; }
		| expresii '/' expresii { char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"/"); strcat(s,$3); $$=s; }
		| expresii '%' expresii {  char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"%"); strcat(s,$3); $$=s;}
		| expresii AND expresii 
		| expresii OR expresii
		| expresii ASSIGN expresii { Check($1); CheckIn($1,$3); char *s=malloc(strlen($1)+strlen($2)+strlen($3)+5); strcpy(s,$1); strcat(s,"="); strcat(s,$3); $$=s;}
		| '(' expresii ')' { $$=$2; }
		| /* empty */
		;
%%
int yyerror(char * s){
	printf("eroare: %s la linia:%d\n",s,yylineno);
}
int main(int argc,char** argv){
	yyin=fopen(argv[1],"r");
	yyparse();
}
