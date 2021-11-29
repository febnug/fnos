build:
	nasm -f bin fnos.asm -o fnos.bin
	nasm -f bin os.asm -o os.bin
	dd if=/dev/zero of=fnos.img bs=1024 count=1440
	dd if=os.bin of=fnos.img conv=notrunc
