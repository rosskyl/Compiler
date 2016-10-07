CC=gcc
FLAGS=-lm
OBJECTS=parser.o scanner.o
EXE=prog

$(EXE):     	$(OBJECTS)
				$(CC) $(FLAGS) -o $(EXE) $(OBJECTS)

parser.o:		parser.c parser.h parser.y
				$(CC) -c parser.c -o parser.o

parser.h:		parser.y parser.tab.h
				mv parser.tab.h parser.h
				
parser.tab.h:	parser.y
				bison -d parser.y
				
parser.tab.c:	parser.y
				bison -d parser.y
			
parser.c:		parser.y parser.tab.c
				mv parser.tab.c parser.c

scanner.o:		scanner.c scanner.lex
				$(CC) -c scanner.c -o scanner.o
				
scanner.c:		scanner.lex lex.yy.c
				mv lex.yy.c scanner.c
				
lex.yy.c:		scanner.lex
				flex scanner.lex

clean:
				rm -rf *.o core.* $(EXE)