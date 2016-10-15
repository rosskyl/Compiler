CC=g++
FLAGS=
OBJECTS=parser.o scanner.o
EXE=prog

$(EXE):     		$(OBJECTS)
			$(CC) -o $(EXE) $(OBJECTS) $(FLAGS)

scope.o:		scope.c scope.h
			$(CC) -c scope.c -o scope.o $(FLAGS)

parser.o:		parser.c parser.h parser.y
			$(CC) -c parser.c -o parser.o $(FLAGS)

parser.h:		parser.y
			bison -d parser.y
			
parser.c:		parser.y
			bison -d parser.y

scanner.o:		scanner.c scanner.lex
			$(CC)  -c scanner.c -o scanner.o $(FLAGS)
				
scanner.c:		scanner.lex
			flex scanner.lex

clean:
			rm -rf *.o core.* $(EXE) parser.c parser.h scanner.c
