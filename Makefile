FILE = ./build/kernel.asm.o

all: clean ./bin/boot.bin ./bin/kernel.bin
	rm -rf os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/kernel.bin: $(FILE)
	i686-elf-ld -g -relocatable $(FILE) -o ./build/kernelfull.o
	i686-elf-gcc -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./build/kernel.asm.o: ./src/kernel.asm
	nasm -f elf ./src/kernel.asm -o ./build/kernel.asm.o
	
./bin/boot.bin: 
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin
clean:
	rm -rf  ./bin/*
	rm -rf ./build/*