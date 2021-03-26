all: calc clean
	

calc: calc2.o
	ld -o $@ $^

calc2.o: calc2.s
	as -a --gstabs -o $@ $^

clean:
	rm -rf *.o
