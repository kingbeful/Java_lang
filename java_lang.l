%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "occ_lang_parse.h"
//#define YY_NO_UNPUT
//struct occ_keyword { const char*name; int tokenType; };
//extern struct occ_keyword *OccGetKeywordToken (const char *str, unsigned int len);
unsigned int lineno = 1;
%}

digital       [[:digit:]]

/*---  Ident  ---*/
name  [[:alpha:]_][[:alnum:]_$]*

%x CCOMMENT
%x LCOMMENT
%x CSTRING

%%
    /* The Line comments */
"//".*         { BEGIN(LCOMMENT); }
<LCOMMENT>.    { yymore(); }
<LCOMMENT>\n   { ++lineno; BEGIN(INITIAL); }

    /* The Content comments */
"/*"           { BEGIN(CCOMMENT); }
<CCOMMENT>.    { yymore(); }
<CCOMMENT>\n   { ++lineno; yymore(); }
<CCOMMENT>"*/" { BEGIN(INITIAL); }

    /* String */
\"           { BEGIN(CSTRING); }
<CSTRING>\\\" { yymore(); }
<CSTRING>\"   {
                BEGIN(INITIAL);
                #ifdef DEBUG
                fprintf (stdout,"%s",yytext);
                #endif 
                #ifdef HAVE_YACC
                //yylval.text = strdup(yytext);
                //yylval.text[strlen(yytext)-1] = 0;
                BEGIN(INITIAL);
                return STRING;
                #endif
               }
<CSTRING>.      { yymore(); }

    /* Eat up the new line */
\n {
    ++lineno;
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
    occyylval.pval = strdup(yytext);
    return NAME_ID ;
    #endif
}

    /* Integer Digital/Number */
{digital}+ {
    #ifdef DEBUG
    fprintf (stdout,"(Num: %s)",yytext);
    #endif
    #ifdef HAVE_YACC
    occyylval.ival = atoi(yytext);
    return DEC_NUMBER;
    #endif
}
    /* Misc */
[=;\{\}./\[\]\(\),] {
    #ifdef DEBUG
    fprintf (stdout,"(Misc: %s)",yytext);
    #endif
    #ifdef HAVE_YACC
    return yytext[0];
    #endif
}

. {
    fprintf (stderr,"L:%d:Syntax error near \'%s\'\n",lineno, yytext);
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
