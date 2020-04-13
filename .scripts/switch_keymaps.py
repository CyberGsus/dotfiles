import os
import subprocess
import itertools
from threading import Thread
from contextlib import redirect_stdout

class Command(Thread):
    def __init__(self, cmd):
        super(Command, self).__init__()
        self.cmd = cmd

    def run(self):
        try:
            os.system(self.cmd)
        except Exception as e:
            print(type(e), e, self.cmd)
        finally:
            return
class Ddict(dict):
    def setdefaults(self, it):
        for k, v in it:
            self.setdefault(k, v)

class KeyboardChanger:
    """
    Right now it is pretty inefficient, but does its job.
    It is a blocking process unless you run it as a thread,
    so make sure to use the '&' at the end of the command if you
    are not testing it.

    This keyboard changer receives the commands shown in `expected_mappings` by
    you creating a file named where you mapped it. To map a file name to a
    function, just use the function name as a keyword argument to the file
    name. The mappings are specified with a non-infinite iterable of strings to
    those mappings. Available commands are:
            - next : Loads the next keyboard map in the list, wrapping  around if
              necessary. File contents don't matter.
            - last: like next, but backwards.
            - jump: Loads the keyboard map specified in the mapped file, and
              sets its current state to it.

    @arg mappings: non-infinite iterable of strings that represent the keyboard
    maps configured for rotating.
    @arg kwargs: optional file names for mapping the functions to them.

    TODO: Create qtile-compatible command for executing the functions directly,
    without 'listening' (no block mode)
    """
    expected_mappings = [
            ('next', 'next'),
            ('last' ,'last'),
            ('jump' , 'jump')
            ]
    def __init__(self, selected, **kwargs):
        self.map = Ddict({ k:v for k, v in kwargs.items() if k in expected_mappings 
            and type(v) == str})
        self.map.setdefaults(KeyboardChanger.expected_mappings)
        self.keymaps = list(selected)
        self._index = 0

    @property
    def index(self):
        return self._index

    @index.setter
    def index(self, val):
        self._index = val % len(self.keymaps)

    def listen(self):
        while True:
            try:
                 for k, v in self.map.items():
                    if os.path.exists(v):
                        self.__getattribute__(k)()
                        os.remove(v)
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(type(e), *e.args)
            finally: 
                continue


    def apply(self, i= None):
        if i is None: i = self.keymaps[self.index]
        if i not in self.keymaps: return
        self.index = self.keymaps.index(i)
        print('Setting to', i)
        Command('setxkbmap {}'.format(i)).start()

    def next(self):
        self.index += 1
        self.apply()
    def last(self):
        self.index -= 1
        self.apply()

    def jump(self):
        try:
            with open(self.map['jump'], 'r') as f: t = f.read().split()[0]
            self.apply(t)
            del t
        finally:
            return













if __name__ == '__main__':
    kbd = KeyboardChanger(['us', 'es'])
    with open('keyboard.log', 'w') as f:
        with redirect_stdout(f):
            kbd.listen()




