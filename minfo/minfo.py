#! /usr/bin/python3

import socket, threading
from queue import Queue
import sdl2, sdl2.ext

ipc_port = 6006
msg_queue = Queue()

def ipc_thread_func():
	with socket.socket() as server:
		server.bind(('', ipc_port))
		server.listen()
		is_running = True
		while is_running:
			client, addr = server.accept()
			with client:
				msg = client.recv(4096)
				if msg == b'show':
					msg_queue.put('show')
					client.send(b'good')
				elif msg == b'hide':
					msg_queue.put('hide')
					client.send(b'good')
				elif msg == b'stop':
					msg_queue.put('stop')
					client.send(b'good')
					is_running = False
				else:
					print('unknown command: ' + msg.decode('utf-8'))
					client.send(b'unknown command')

def draw_thread_func():

	sdl2.ext.init()
	#font = sdl2.ext.FontManager('/home/jamie/.local/share/fonts/System San Francisco Display Bold.ttf')
	font = sdl2.ext.FontManager('/usr/share/fonts/truetype/open-sans-elementary/OpenSans-Bold.ttf')
	sprite_factory = sdl2.ext.SpriteFactory(sdl2.ext.SOFTWARE)

	class Module:
		def __init__(self):
			self.window = sdl2.ext.Window(
				'minfo',
				(200, 100),
				flags = sdl2.SDL_WINDOW_BORDERLESS or sdl2.SDL_WINDOW_HIDDEN
			)
			self.renderer = sprite_factory.create_sprite_render_system(self.window)
			self.name_surface = None
			self.name_sprite = None
			self.name = 'module'

		@property
		def name(self):
			return self._name

		@name.setter
		def name(self, name):
			self._name = name
			self.name_surface = font.render(self.name.upper())
			self.name_sprite = sprite_factory.from_surface(self.name_surface)

		def show(self):
			self.window.show()

		def hide(self):
			self.window.hide()

		def set_position(self, x, y):
			sdl2.SDL_SetWindowPosition(self.window.window, x, y)

		def draw(self):
			self.renderer.render(self.name_sprite)

	class TimeModule(Module):
		def __init__(self):
			super().__init__()
			self.name = 'time'

	class DateModule(Module):
		def __init__(self):
			super().__init__()
			self.name = 'date'

	class AudioModule(Module):
		def __init__(self):
			super().__init__()
			self.name = 'audio'

	time_mod = TimeModule()
	time_mod.set_position(50, 50)
	time_mod.draw()
	date_mod = DateModule()
	date_mod.set_position(50, 50 + 125 * 1)
	date_mod.draw()
	audio_mod = AudioModule()
	audio_mod.set_position(50, 50 + 125 * 2)
	audio_mod.draw()

	is_running = True
	while is_running:
		msg = msg_queue.get()
		print('draw msg: ' + msg)
		if msg == 'stop':
			is_running = False
		elif msg == 'show':
			time_mod.show()
			date_mod.show()
			audio_mod.show()
		elif msg == 'hide':
			time_mod.hide()
			date_mod.hide()
			audio_mod.hide()
	sdl2.ext.quit()


ipc_thread = threading.Thread(target=ipc_thread_func)
ipc_thread.start()
draw_thread_func()
ipc_thread.join()
