%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define YYSTYPE char*

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
int yywrap();
%}

%token METHOD
%token SLASH
%token VERSION
%token NEWLINE
%token STRING
%token ID
%token COLON

%%

REQUEST: METHOD {
       printf("Method: %s", yylval);
    }
    URI {
    }
    VERSION {
    }
    NEWLINE {
    }
    HEADERS {
    printf("DONE\n");
    }
;

URI: SLASH {
    }
    DIR {
    }
;

DIR: ID SLASH
    |ID
    |
    ;

HEADERS: HEADER {
    }
    HEADERS {
    }
    |
;

HEADER: ID {
    }
    COLON {
    }
    STRING {
    }
    NEWLINE {
    }
;

%%

void yyerror (char const *s) {
   fprintf(stderr, "Poruka nije tacna\n");
}

int yywrap() {
    return 1;
}

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

    return 0;
}
