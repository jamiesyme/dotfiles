#! /usr/bin/python3

import socket

ipc_port = 6006

#msgs = [b'show', b'hide', b'fjaskld', b'stop']
msgs = [b'stop']

for msg in msgs:
	with socket.socket() as sock:
		sock.connect(('localhost', ipc_port))
		sock.send(msg)
