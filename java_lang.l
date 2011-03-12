%option stack
%option yylineno
%option nounput
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "java_lang_parse.h"
#define YY_NO_UNPUT
struct java_keyword { const char * name; int tokenType; };
const struct java_keyword *key_token;
extern struct java_keyword *JavaLangGetKeywordToken (const char * str, unsigned int len);
%}

digital       [[:digit:]]

/*---  Ident  ---*/
name  [[:alpha:]_][[:alnum:]_$]*

%x CCOMMENT
%x LCOMMENT
%x CSTRING
%x CBODY

%%
    /* The Line comments */
"//"           { yy_push_state(LCOMMENT); }
<LCOMMENT>.*   { yymore(); }
<LCOMMENT>\n   { yy_pop_state (); }

    /* The Content comments */
"/*"           { yy_push_state(CCOMMENT); }
<CCOMMENT>.    { yymore(); }
<CCOMMENT>\n   { yymore(); }
<CCOMMENT>"*/" { yy_pop_state (); }

    /* String */
\"           { BEGIN(CSTRING); }
<CSTRING>\\\" { yymore(); }
<CSTRING>\"   {
                BEGIN(INITIAL);
                #ifdef DEBUG
                fprintf (stdout,"%s",yytext);
                #endif 
                #ifdef HAVE_YACC
                javayylval.pval = strdup(yytext);
                javayylval.pval[strlen(yytext)-1] = 0;
                return STRING;
                #endif
               }
<CSTRING>[^\"] { yymore(); }

    /* Program Body */
\{           { yy_push_state(CBODY);}
<CBODY>\}    { yy_pop_state (); }
<CBODY>\{    { yy_push_state(CBODY); }
<CBODY>\n    { yymore(); }
<CBODY>"/*"  { yy_push_state(CCOMMENT); }
<CBODY>"//"  { yy_push_state(LCOMMENT); }
<CBODY>[^\}\{]+  { yymore(); }

    /* Eat up the new line */
\n {
    #ifdef DEBUG
    fprintf (stdout,"%s",yytext);
    #endif
}
    /* Eat up the space */
[ \t]+ {
    #ifdef DEBUG
    fprintf (stdout,"%s",yytext);
    #endif
}


    /* Ident */
{name} {
    #ifdef DEBUG
    fprintf (stdout,"(ID: %s)",yytext);
    #endif
    #ifdef HAVE_YACC
    key_token = JavaLangGetKeywordToken(yytext, strlen(yytext));
    if (key_token == 0) {
       javayylval.pval = strdup(yytext);
       return NAME_ID ;
    }
    else {
       #ifdef DEBUG
       fprintf (stdout,"KeyWD");
       #endif
       return key_token->tokenType;
    }
    #endif
}

    /* Integer Digital/Number */
{digital}+ {
    #ifdef DEBUG
    fprintf (stdout,"(Num: %s)",yytext);
    #endif
    #ifdef HAVE_YACC
    javayylval.ival = atoi(yytext);
    return NUMBER;
    #endif
}
    /* Misc */
[\<\>\[\]\(\),] {
    #ifdef DEBUG
    fprintf (stdout,"(Misc: %s)",yytext);
    #endif
    #ifdef HAVE_YACC
    return yytext[0];
    #endif
}

. {
    fprintf (stderr,"L:%d:Syntax error near \'%s\'\n",yylineno, yytext);
    exit (-1);
}

%%
#ifndef HAVE_YACC
int main()
{
    yyin = fopen("test.java", "r");
    yylex();

    return 0;
}
#endif
int yywrap() {
    return 1;
}
