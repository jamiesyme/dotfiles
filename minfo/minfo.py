#! /usr/bin/python3

import socket, threading
from queue import Queue
import sdl2.ext

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
    #font = sdl2.ext.FontManager('System San Francisco Display Bold.ttf')
    font = sdl2.ext.FontManager('/home/jamie/.local/share/fonts/System San Francisco Display Bold.ttf')
    font_surf = font.render('TIME')
    window = sdl2.ext.Window('minfo', (200, 100))
    window.show()
    sprite_factory = sdl2.ext.SpriteFactory(sdl2.ext.SOFTWARE)
    renderer = sprite_factory.create_sprite_render_system(window)
    sprite = sprite_factory.from_surface(font_surf)
    renderer.clear((0, 0, 0, 0))
    renderer.render(sprite)
    is_running = True
    while is_running:
        msg = msg_queue.get()
        print('draw msg: ' + msg)
        if msg == 'stop':
            is_running = False
    sdl2.ext.quit()


ipc_thread = threading.Thread(target=ipc_thread_func)
ipc_thread.start()
draw_thread_func()
ipc_thread.join()
