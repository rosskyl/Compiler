CC=g++
OBJECTS=parser.o scanner.o globals.o scope.o nodes.o #createNodes.o
EXE=prog

$(EXE):     		$(OBJECTS)
			$(CC) -o $(EXE) $(OBJECTS)

#createNodes.o:		createNodes.cpp createNodes.h nodes.h
#			$(CC) -c createNodes.cpp -o createNodes.o

nodes.o:		nodes.cpp nodes.h
			$(CC) -c nodes.cpp -o nodes.o

scope.o:		scope.cpp scope.h parser.y
			$(CC) -c scope.cpp -o scope.o

globals.o:		globals.cpp globals.h scope.h nodes.h
			$(CC) -c globals.cpp -o globals.o

parser.o:		parser.c parser.y globals.h nodes.h
			$(CC) -c parser.c -o parser.o

parser.h:		parser.y globals.h nodes.h
			bison -d parser.y
			
parser.c:		parser.y
			bison -d parser.y

scanner.o:		scanner.c scanner.lex globals.h
			$(CC)  -c scanner.c -o scanner.o
				
scanner.c:		scanner.lex
			flex scanner.lex

clean:
			rm -rf *.o core.* $(EXE) parser.c parser.h scanner.c
