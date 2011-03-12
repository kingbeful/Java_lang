%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern FILE* javayyin;
extern int javayylineno;
extern char* javayytext;
extern int javayylex ();

typedef struct java_paras_stru {
    char * type;
    char * name;
    struct java_paras_stru *next;
} JAVA_Paras;

typedef struct java_method_stru {
    char * return_type;
    char * name;
    JAVA_Paras * pParas;
    struct java_method_stru * next;
} JAVA_Method;

int method_num = 0;
JAVA_Method * pMethodHead = NULL;
JAVA_Method * pMethodPre = NULL;
JAVA_Method * pMethodCur = NULL;
JAVA_Paras * pParasHead = NULL;
JAVA_Paras * pParasPre = NULL;
JAVA_Paras * pParasCur = NULL;

void yyerror(char *msg);
%}
%union  {
    int ival;
    char * pval;
}

%token K_PUBLIC
%token K_PRIVATE
%token K_PROTECTED
%token K_INT
%token K_CLASS
%token K_STRING
%token K_STATIC
%token K_NEW
%token K_VOID
%token K_RETURN
%token <pval> STRING
%token <pval> NAME_ID
%type <pval> vector
%type <pval> array
%type <pval> special_return
%token <ival> NUMBER

%start java_methods

%%



java_methods
    : java_method
    | java_methods java_method
    ;

java_method
    : K_PUBLIC K_INT NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = strdup("int");
            pMethodCur->name = $3;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    | K_PUBLIC K_STRING NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = strdup("String");
            pMethodCur->name = $3;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    | K_PUBLIC NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = strdup("None");
            pMethodCur->name = $2;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    | K_PUBLIC NAME_ID NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = $2;
            pMethodCur->name = $3;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    | K_PUBLIC special_return NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = $2;
            pMethodCur->name = $3;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    | K_PUBLIC K_VOID NAME_ID '(' java_paras ')' {
        if (!pMethodCur) {
            pMethodCur = (JAVA_Method *)malloc(sizeof(JAVA_Method));
            pMethodCur->return_type = strdup("void");
            pMethodCur->name = $3;
            pMethodCur->pParas = pParasHead;
            pMethodCur->next = NULL;
        }
        if (pMethodPre) {
            pMethodPre->next = pMethodCur;
        } else {
            pMethodHead = pMethodCur;
        }
        pMethodPre = pMethodCur;
        pMethodCur = NULL;
        pParasHead = NULL;
        pParasPre = NULL;
        pParasCur = NULL;
        method_num++;
    }
    ;

special_return 
    : vector {
        $$ = $1;
    }
    | array {
        $$ = $1;
    }
    ;

vector
    : NAME_ID '<' NAME_ID '>' {
        char* p = (char* )malloc(sizeof(char)*(strlen($1) + strlen($3) + 3));
        p[0] = '\0';
        sprintf(p,"%s<%s>", $1, $3);
        $$=p;
    }
    | NAME_ID '<' K_STRING '>' {
        char* p = (char* )malloc(sizeof(char)*(strlen($1) + strlen("String") + 3));
        p[0] = '\0';
        sprintf(p,"%s<String>", $1);
        $$=p;
    }
    ;

array
    : NAME_ID '[' ']' {
        char* p = (char* )malloc(sizeof(char)*(strlen($1) + 3));
        p[0] = '\0';
        sprintf(p,"%s[]", $1);
        $$=p;
    }
    ;

java_paras
    : java_para
    | java_paras ',' java_para
    ;

java_para
    : K_INT NAME_ID {
        if (!pParasCur) {
            pParasCur = (JAVA_Paras *)malloc(sizeof(JAVA_Paras));
            pParasCur->type = strdup("int");
            pParasCur->name = $2;
            pParasCur->next = NULL;
        }
        if (pParasPre) {
            pParasPre->next = pParasCur;
        } else {
            pParasHead = pParasCur;
        }
        pParasPre = pParasCur;
        pParasCur = NULL;
    }
    | K_STRING NAME_ID {
        if (!pParasCur) {
            pParasCur = (JAVA_Paras *)malloc(sizeof(JAVA_Paras));
            pParasCur->type = strdup("String");
            pParasCur->name = $2;
            pParasCur->next = NULL;
        }
        if (pParasPre) {
            pParasPre->next = pParasCur;
        } else {
            pParasHead = pParasCur;
        }
        pParasPre = pParasCur;
        pParasCur = NULL;
    }
    | K_STRING '[' ']' NAME_ID {
        if (!pParasCur) {
            pParasCur = (JAVA_Paras *)malloc(sizeof(JAVA_Paras));
            pParasCur->type = strdup("String[]");
            pParasCur->name = $4;
            pParasCur->next = NULL;
        }
        if (pParasPre) {
            pParasPre->next = pParasCur;
        } else {
            pParasHead = pParasCur;
        }
        pParasPre = pParasCur;
        pParasCur = NULL;
    }
    | NAME_ID NAME_ID  {
        if (!pParasCur) {
            pParasCur = (JAVA_Paras *)malloc(sizeof(JAVA_Paras));
            pParasCur->type = $1;
            pParasCur->name = $2;
            pParasCur->next = NULL;
        } 
        if (pParasPre) {
            pParasPre->next = pParasCur;
        } else {
            pParasHead = pParasCur;
        }
        pParasPre = pParasCur;
        pParasCur = NULL;
    }
    | special_return NAME_ID  {
        if (!pParasCur) {
            pParasCur = (JAVA_Paras *)malloc(sizeof(JAVA_Paras));
            pParasCur->type = $1;
            pParasCur->name = $2;
            pParasCur->next = NULL;
        }
        if (pParasPre) {
            pParasPre->next = pParasCur;
        } else {
            pParasHead = pParasCur;
        }
        pParasPre = pParasCur;
        pParasCur = NULL;
    }
    ;


%%

int main (int argc, char ** argv)
{
    JAVA_Method * pmethod;
    JAVA_Paras * pparas;
    if (argc == 1) {
        javayyin = fopen("test.java", "r");
    } else {
        javayyin = fopen(argv[1], "r");
    }
    yyparse();
    if (pMethodHead) {
    pmethod = pMethodHead;
    while (pmethod) {
       fprintf(stdout, "===================================\n");
       fprintf(stdout, "=== Method type : %s\n", pmethod->return_type);
       fprintf(stdout, "=== Method name : %s\n", pmethod->name);
       fprintf(stdout, "---------- Parameter List ---------\n");
       pparas = pmethod->pParas;
       while (pparas) {
       fprintf(stdout, "--- %s %s\n", pparas->type, pparas->name);
       pparas = pparas->next;
       }
       fprintf(stdout, "===================================\n");
       pmethod = pmethod->next;
    }
    }
    return 0;
}

void yyerror(char *msg)
{
    fprintf(stderr,"L:%d:Error in Parser near \'%s\' : %s\n\n", javayylineno, javayytext, msg);
    exit (-1);
}
