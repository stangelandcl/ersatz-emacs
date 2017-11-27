# The name to install the editor and documentation under. Long-time microemacs
# users might prefer "me" or "uemacs" instead.
EXEC=ee

CFLAGS=-Wall -O2
# To be /really/ fanatical on the executible's size...
#CFLAGS=-Os -fomit-frame-pointer -malign-loops=0 -malign-jumps=0 -malign-functions=0 -Wall

# Uncomment to force the screen size, in situtations were it is desirable or
# if your system lacks the TIOCGWINSZ ioctl.
#DUMBCONS= -DFORCE_COLS=80 -DFORCE_ROWS=24

# NetBSD, Linux, and nearly all other POSIX-based enviroments
#LFLAGS= -ltermcap
# Try this on some older systems
LFLAGS= -lncursesw -ltinfow
# For very early Linux
#LFLAGS= -lbsd

# If you should change DOCDIR, be certain to update the path mentioned
# in the man page.
PREFIX= /usr/local
DOCDIR= ${PREFIX}/share
BINDIR=	${PREFIX}/bin
MANDIR=	${PREFIX}/man/man1

EXTRA=	README Makefile ERSATZ.keys ee.1 ChangeLog

HFILES=	estruct.h edef.h efunc.h ebind.h

CFILES=	basic.c buffer.c display.c file.c fileio.c line.c main.c \
	random.c region.c search.c tcap.c termio.c window.c word.c

OFILES=	basic.o buffer.o display.o file.o fileio.o line.o main.o \
	random.o region.o search.o tcap.o termio.o window.o word.o

all:	$(OFILES)
	$(CC) $(CFLAGS) $(OFILES) -o $(EXEC) $(LFLAGS)

install: all
	install -c -m 0755 -o bin -g bin -s $(EXEC) $(BINDIR)
	install -c -m 0444 -o bin -g bin ERSATZ.keys $(DOCDIR)
	install -c -m 0644 -o bin -g bin ee.1 $(MANDIR)/$(EXEC).1

clean:
	rm -f *.o *~ *.core *.bak ersatz.shar $(EXEC)

backup:
	-mv -f backup01.tar.gz backup02.tar.gz
	-mv -f backup00.tar.gz backup01.tar.gz
	tar zcf backup00.tar.gz $(CFILES) $(HFILES) $(EXTRA)

shar:	clean
	shar $(EXTRA) $(HFILES) $(CFILES) >ersatz.shar

floppy:
	tar cvf /dev/fd0a $(EXTRA) $(CFILES) $(HFILES)

basic.o: basic.c estruct.h edef.h
buffer.o: buffer.c estruct.h edef.h
display.o: display.c estruct.h edef.h
file.o: file.c estruct.h edef.h
fileio.o: fileio.c estruct.h
line.o: line.c estruct.h edef.h
main.o: main.c estruct.h edef.h efunc.h ebind.h
random.o: random.c estruct.h edef.h
region.o: region.c estruct.h edef.h
search.o: search.c estruct.h edef.h
tcap.o: tcap.c estruct.h edef.h
	$(CC) $(CFLAGS) $(DUMBCONS) -c $<
termio.o: termio.c
window.o: window.c estruct.h edef.h
word.o: word.c estruct.h edef.h
