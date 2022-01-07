%{
    #include<stdio.h>
    #include "request.tab.h"
    char *strclone(char *str);
%}

num                                     [0-9]+(\.[0-9]{1,2})?
letter                                  [a-zA-Z]
letternum                               [a-zA-Z0-9\-]
id                                      {letter}{letternum}*
string                                  \"[^"]*\"
fieldvalue                              {string}|{num}

%%

(GET|HEAD|POST|PUT|DELETE|OPTIONS)      { yylval = strclone(yytext); return METHOD; }
HTTP\/{num}                             { return VERSION; }
{id}                                    { return ID; }
"/"                                     { return SLASH; }
"\n"                                    { return NEWLINE; }
{string}                                { return STRING; }
":"                                     { return COLON; }
[ \t\n]+                                       ;
. {
    printf("Unexpected: %c\nExiting...\n", *yytext);
    exit(0);
}

%%

char *strclone(char *str) {
    int len = strlen(str);
    char *clone = (char *)malloc(sizeof(char)*(len+1));
    strcpy(clone,str);
    return clone;
}
