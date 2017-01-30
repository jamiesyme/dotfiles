CC=gcc

MINFO_CFLAGS=-Wall $(shell pkg-config --cflags pangocairo x11)
MINFO_LDFLAGS=$(shell pkg-config --libs pangocairo x11)
MINFO_SOURCES=src/main.c src/hub.c src/radio-receiver.c

MINFO_MSG_CFLAGS=-Wall
MINFO_MSG_LDFLAGS=
MINFO_MSG_SOURCES=src/minfo-msg.c src/radio-transmitter.c

all: minfo minfo_msg

minfo: $(MINFO_SOURCES)
	@$(CC) $(MINFO_CFLAGS) $(MINFO_SOURCES) $(MINFO_LDFLAGS) -o minfo

minfo_msg: $(MINFO_MSG_SOURCES)
	@$(CC) $(MINFO_MSG_CFLAGS) $(MINFO_MSG_SOURCES) $(MINFO_MSG_LDFLAGS) -o minfo-msg
