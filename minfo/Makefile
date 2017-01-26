CFLAGS=-Wall $(shell pkg-config --cflags pangocairo x11)
LDFLAGS=$(shell pkg-config --libs pangocairo x11)
CC=gcc

all: src/main.c
	@$(CC) $(CFLAGS) src/main.c $(LDFLAGS)
