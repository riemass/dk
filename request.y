%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define YYSTYPE char*

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token METHOD
%token SLASH
%token VERSION
%token STRING
%token ID
%token COLON
%token NEWLINE

%%

REQUEST: METHOD URI VERSION NEWLINE HEADERS {
       printf("%s %s", $1, $2);
    }
;

URI: SLASH DIR {
        $$ = (char *)malloc(sizeof(char)*(1+strlen($2)+1));
        sprintf($$, "//%s", $2);
    }
;

DIR: ID SLASH {
        $$ = (char *)malloc(sizeof(char)*(strlen($1)+2));
        sprintf($$, "%s//", $1);
    }
    |ID {
        $$ = $1;
    }
    | {
        $$ = "";
    }
;

HEADERS: HEADER {
        $$ = $1;
    }
    |HEADER NEWLINE HEADERS {
        $$ = (char *)malloc(sizeof(char)*(strlen($1)+1+strlen($3)+1));
        sprintf($$, "%s\n%s", $1, $3);
    }
    |{
        $$ = "";
    }
;

HEADER: ID COLON STRING {
        $$ = (char *)malloc(sizeof(char)*(strlen($1)+1+strlen($2)+1));
        sprintf($$, "%s:%s", $1, $3);
    }
;

%%

void yyerror (char const *s) {
   fprintf(stderr, "Poruka nije tacna\n");
}

int main() {
    yydebug = 1;
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

    return 0;
}
