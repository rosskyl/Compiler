CC=g++
OBJECTS=parser.o scanner.o globals.o scope.o
EXE=prog

$(EXE):     		$(OBJECTS)
			$(CC) -o $(EXE) $(OBJECTS)

scope.o:		scope.cpp scope.h
			$(CC) -c scope.cpp -o scope.o

globals.o:		globals.cpp globals.h
			$(CC) -c globals.cpp -o globals.o

parser.o:		parser.c parser.h parser.y globals.h
			$(CC) -c parser.c -o parser.o

parser.h:		parser.y
			bison -d parser.y
			
parser.c:		parser.y
			bison -d parser.y

scanner.o:		scanner.c scanner.lex globals.h
			$(CC)  -c scanner.c -o scanner.o
				
scanner.c:		scanner.lex
			flex scanner.lex

clean:
			rm -rf *.o core.* $(EXE) parser.c parser.h scanner.c
