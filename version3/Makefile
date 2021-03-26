all: calc clean
	
calc: fonctCalc.o calc3.s
	gcc -g -static fonctCalc.o calc3.s -o calc

fonctCalc.o: fonctCalc.c
	gcc -c -Wall -Wextra $<

clean:
	rm -rf *.o
