CC=g++
OBJECTS=parser.o scanner.o globals.o scope.o nodes.o createNodes.o
EXE=prog
MFLAGS=`llvm-config --cxxflags --ldflags --system-libs --libs core`

$(EXE):     		$(OBJECTS)
			$(CC) -o $(EXE) $(MFLAGS) $(OBJECTS) $(MFLAGS)

createNodes.o:		createNodes.cpp createNodes.h nodes.h
			$(CC) -c createNodes.cpp $(MFLAGS) -o createNodes.o

nodes.o:		nodes.cpp nodes.h
			$(CC) -c nodes.cpp $(MFLAGS) -o nodes.o

scope.o:		scope.cpp scope.h parser.y
			$(CC) -c scope.cpp $(MFLAGS) -o scope.o

globals.o:		globals.cpp globals.h scope.h nodes.h
			$(CC) -c globals.cpp $(MFLAGS) -o globals.o

parser.o:		parser.c parser.y globals.h nodes.h createNodes.h
			$(CC) -c parser.c $(MFLAGS) -o parser.o

parser.h:		parser.y globals.h nodes.h createNodes.h
			bison -d parser.y
			
parser.c:		parser.y globals.h nodes.h createNodes.h
			bison -d parser.y

scanner.o:		scanner.c scanner.lex globals.h
			$(CC)  -c scanner.c $(MFLAGS) -o scanner.o
				
scanner.c:		scanner.lex
			flex scanner.lex

clean:
			rm -rf *.o core.* $(EXE) parser.c parser.h scanner.c
