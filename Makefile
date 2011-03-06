LEX  = flex
YACC = bison
CC = gcc
SRCS = lex.javayy.c 
OBJS = $(SRCS:.c=.o)
COMPILE_OPTION = -DDEBUG
BIN_LEX = javalex

.SUFFIXES: .c .o

.c.o:
	$(CC) -c $(COMPILE_OPTION) $*.c

help:
	@echo "This Makefile is used to compile the parser for Java."
	@echo "Please use one of the following:"
	@echo "-----------------------------------------------------"
	@echo "make lex ...... to build main.hex"
	@echo "make parser ... to flash fuses and firmware"
	@echo "make clean .... to remove all the file during compile"

lex: lex.javayy.o
	$(CC) -o $(BIN_LEX) lex.javayy.o

lex.javayy.c : java_lang.l
	$(LEX) -Cf --verbose -Pjavayy java_lang.l

clean:
	rm -f *.out *.o lex.javayy.c $(BIN_LEX)
