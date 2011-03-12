LEX  = flex
YACC = bison
CC = gcc
SRCS = lex.javayy.c java_keyword.c java_lang_parse.c
OBJS = $(SRCS:.c=.o)
COMPILE_OPTION = -Wall
ifeq ($(MAKECMDGOALS), lex)
COMPILE_OPTION := $(COMPILE_OPTION) -g -DDEBUG
endif

ifeq ($(MAKECMDGOALS),parser)
COMPILE_OPTION := $(COMPILE_OPTION) -O3 -DHAVE_YACC -DDEBUG
endif

BIN_LEX = javalex
BIN_PAR = jack

.SUFFIXES: .c .o

.c.o:
	$(CC) -c $(COMPILE_OPTION) $*.c

help:
	@echo "This Makefile is used to compile the parser for Java."
	@echo "Please use one of the following:"
	@echo "-----------------------------------------------------"
	@echo "make lex ...... to only build lex"
	@echo "make parser ... to build the parser"
	@echo "make clean .... to remove all the file during compile"

lex: lex.javayy.o
	$(CC) -o $(BIN_LEX) lex.javayy.o

lex.javayy.c : java_lang.l java_lang_parse.h
	$(LEX) -Cf --verbose -Pjavayy java_lang.l

java_keyword.c : java_keyword.gperf java_lang_parse.h
	gperf -o  -k 1-3,$$ -L C -H keyword_hash -N JavaLangGetKeywordToken -t java_keyword.gperf > java_keyword.c

java_lang_parse.c java_lang_parse.h : java_lang.y
	$(YACC) --verbose -t -d -p javayy -o java_lang_parse.c java_lang.y

parser: $(OBJS)
	$(CC) -o $(BIN_PAR) $(OBJS)  

clean:
	rm -f *.out *.o lex.javayy.c $(BIN_LEX) $(BIN_PAR) java_keyword.c java_lang_parse.c java_lang_parse.h 
