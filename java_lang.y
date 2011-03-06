%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int lineno;
extern char* yytext;
extern int javayylex ();

void yyerror(char *msg);
%}
%union  {
    int ival;
    char * pval;
}

%token K_PUBLIC
%token K_PRIVATE
%token K_INT
%token K_CLASS
%token K_STRING
%token K_STATIC
%token K_ARRAYLIST
%token K_NEW
%token K_VOID
%token K_RETURN

%start java_file

%%

java_file
    : K_CLASS 
    ;

%%
void yyerror(char *msg)
{
    fprintf(stderr,"L:%d:Error in Parser: %s\n\n", lineno, msg);
    exit (-1);
}
