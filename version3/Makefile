all: calc clean
	
calc: fonctCalc.o tp4.s
	gcc -g -static fonctCalc.o tp4.s -o calc

fonctCalc.o: fonctCalc.c
	gcc -c -Wall -Wextra $<

clean:
	rm -rf *.o
