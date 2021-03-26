all: calc clean
	

calc: calc1.o
	ld -o $@ $^

calc1.o: calc1.s
	as -a --gstabs -o $@ $^

clean:
	rm -rf *.o
