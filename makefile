CC	= gcc
CFLAGS	= -g -O -DHAVE_WX   -DX_DISPLAY_MISSING -O0 -DUSE_OLD_TTY
CXX     = g++
CXXFLAGS = -g  -DHAVE_WX -I/usr/local/lib/wx/include/osx_cocoa-unicode-3.1 -I/usr/local/include/wx-3.1 -D_FILE_OFFSET_BITS=64 -DWXUSINGDLL -D__WXMAC__ -D__WXOSX__ -D__WXOSX_COCOA__ 
LDFLAGS	= 
LIBS  =   -lm  -L/usr/local/lib   -framework IOKit -framework Carbon -framework Cocoa -framework AudioToolbox -framework System -framework OpenGL -lwx_osx_cocoau_xrc-3.1 -lwx_osx_cocoau_html-3.1 -lwx_osx_cocoau_qa-3.1 -lwx_osx_cocoau_adv-3.1 -lwx_osx_cocoau_core-3.1 -lwx_baseu_xml-3.1 -lwx_baseu_net-3.1 -lwx_baseu-3.1  -ltermcap 
prefix = /usr/local
BINDIR        = $(prefix)/bin
LIBLOC        = $(prefix)/lib/logo
LINKER = $(CXX)

# LIBLOC      = `pwd`

OBJS 	= coms.o error.o eval.o files.o graphics.o init.o intern.o \
	  libloc.o lists.o logodata.o main.o math.o mem.o paren.o parse.o \
	  print.o wrksp.o nographics.o svn.o wxMain.o wxTerminal.o wxTurtleGraphics.o  TextEditor.o wxterm.o 

SRCS	= coms.c error.c eval.c files.c graphics.c init.c intern.c \
	  libloc.c lists.c logodata.c main.c math.c mem.c paren.c parse.c \
	  print.c wrksp.c nographics.c wxMain.cpp wxTerminal.cpp wxTurtleGraphics.cpp  TextEditor.cpp wxterm.c 

HDRS	= globals.h logo.h xgraphics.h

logo:	$(OBJS)
	$(LINKER) $(CFLAGS) $(LDFLAGS) $(OBJS) $(LIBS) -o logo

everything:	logo logolib/Messages helpfiles helpfiles/HELPCONTENTS
#logo-mode

mem.o:	mem.c
	$(CC) $(CFLAGS) -O0 -c mem.c

svn.c:	$(SRCS)
	echo 'char* SVN = "('`svnversion|tr -d '\r'`')";' > svn.c

tags:	$(SRCS)
	ctags --format=1 -N $(SRCS) $(HDRS)
# 	ctags -t $(SRCS) $(HDRS)

libloc.c:
	echo 'char *libloc="'$(LIBLOC)'/logolib";' > libloc.c
	echo 'char *helploc="'$(LIBLOC)'/helpfiles";' >> libloc.c
	echo 'char *cslsloc="'$(LIBLOC)'/csls";' >> libloc.c
	echo 'char *temploc="/tmp";' >> libloc.c
	echo 'char *separator="/";' >> libloc.c

logolib/Messages:	makelib Messages
	chmod +x makelib
	./makelib
	cp -f Messages logolib

helpfiles:
	mkdir helpfiles

helpfiles/HELPCONTENTS:	makehelp usermanual
	./makehelp
	sort helptemp | pr -5 -t -l999 -w80 >> helpfiles/HELPCONTENTS
	rm helptemp

makehelp:	makehelp.c
	$(CC) -o makehelp makehelp.c

clean:
	rm -f *.o libloc.c
#	cd emacs; $(MAKE) clean

ship:
	rm -f config.h config.cache config.log config.status
	rm -f makefile makehelp logo *.o libloc.c
#	cd emacs; $(MAKE) ship
	cd docs; $(MAKE) ship

install: all
	for d in $(BINDIR) $(LIBLOC) $(LIBLOC)/logolib $(LIBLOC)/helpfiles $(LIBLOC)/csls; do [ -d $$d ] || mkdir -p $$d || exit 1; done
	cp logo $(BINDIR)/.
	cp -f logolib/* $(LIBLOC)/logolib/.
	cp -f helpfiles/* $(LIBLOC)/helpfiles/.
	cp -f csls/* $(LIBLOC)/csls/.
#	(cd emacs; prefix=$(prefix) LIBLOC=$(LIBLOC) BINDIR=$(BINDIR) $(MAKE) install)
	(cd docs; prefix=$(prefix) LIBLOC=$(LIBLOC) BINDIR=$(BINDIR) $(MAKE) install)
#	prefix=$(prefix); LIBLOC=$(LIBLOC); BINDIR=$(BINDIR); export prefix LIBLOC BINDIR; cd emacs; $(MAKE) install

logo-mode: 
#	(cd emacs; prefix=$(prefix) LIBLOC=$(LIBLOC) BINDIR=$(BINDIR) $(MAKE))
#	@prefix=$(prefix); LIBLOC=$(LIBLOC); BINDIR=$(BINDIR); export prefix LIBLOC BINDIR; cd emacs; $(MAKE)

make-docs:
	(cd docs; prefix=$(prefix) LIBLOC=$(LIBLOC) $(MAKE) all)

mac: logo
	mkdir -p UCBLogo.app
	mkdir -p UCBLogo.app/Contents
	cp Info.plist UCBLogo.app/Contents/
	cp PkgInfo UCBLogo.app/Contents/
	cp pbdevelopment.plist UCBLogo.app/Contents/
	mkdir -p UCBLogo.app/Contents/Resources/csls
	cp csls/[a-z]* UCBLogo.app/Contents/Resources/csls
	cp -r helpfiles UCBLogo.app/Contents/Resources/
	cp -r logolib UCBLogo.app/Contents/Resources/
	cp logo.icns UCBLogo.app/Contents/Resources/
	mkdir -p UCBLogo.app/Contents/MacOS/
	cp logo UCBLogo.app/Contents/MacOS/UCBLogo
