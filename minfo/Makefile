CFLAGS=-Wall $(shell pkg-config --cflags pangocairo x11)
LDFLAGS=$(shell pkg-config --libs pangocairo x11)
CC=gcc

SOURCES=src/main.c src/hub.c

all: $(SOURCES)
	@$(CC) $(CFLAGS) $(SOURCES) $(LDFLAGS)
