from contextlib import redirect_stdout
from functools import wraps
from itertools import cycle
from libqtile.command import lazy
from os import system
from subprocess import check_output
from threading import Thread
import time


def one_call(func):
    """
    Makes function call just once,
    getting its return value and caching it.

    WARNING: No matter which parameters you modify,
    function return is function call. Can be used for
    avoiding the initialization of new objects.
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return wrapper.return_value
        except AttributeError:
            wrapper.return_value = func(*args, **kwargs)
            return wrapper.return_value
    return wrapper


class InfiniteTimer(Thread):
    """
    A timer that runs again and again,
    indifinetly
    """

    def __init__(self, timeout, callback, *args, **kwargs):
        super(InfiniteTimer, self).__init__()
        self.kwargs = kwargs
        self.args = args
        self.timeout = timeout
        self.callback = callback
        self.running = True

    def cancel(self):
        self.running = False

    def run(self):
        while self.running:
            time.sleep(self.timeout)
            self.callback(*self.args, **self.kwargs)


class RedShift:

    @staticmethod
    def check_available():
        try:
            val = check_output(['redshift', '-h'])
            del val
            return True
        except OSError:
            return False

    """
    A wrapper for adjusting/iterating
    through redshift

    @param values: a finite iterable with
    integer values.
    """

    def __init__(self, values):
        self.available = RedShift.check_available()
        if not self.available:
            print(
                """\x1b[31;1m[RedShift] \x1b[31;0mRedshift binary is not available, therefore every instruction
will be ignored.\x1b[m""")
        self.values = []
        for i in values:
            try:
                n = int(i)
                self.values.append(n)
            except ValueError:
                continue
        self.values = tuple(self.values)
        self.cycle = cycle(self.values)
        self.current_value = 0
        self.devnull = open('/dev/null', 'w')

    @lazy.function
    def reset(self, qtile):
        if not self.available:
            return
        with redirect_stdout(self.devnull):
            os.system('redshift -x')

    @lazy.function
    def next(self, qtile):
        # TODO : add command options
        if not self.available:
            return
        self.current_value = next(self.cycle)
        with redirect_stdout(self.devnull):
            os.system(f'redshift -PO  {self.current_value}')
        print(
            f"""\x1b[1;38;5;118m[RedShift] \x1b[0;38;5;118mChanged value to '{self.current_value}'\x1b[m'""")

    def __del__(self):
        print("[RedShift] Shutting down...")
        if not self.devnull.closed:
            self.devnull.close()


def singleton(cls):
    def start(*args, **kwargs):
        if not start.instance:
            start.instance = start.cls(*args, **kwargs)
        return start.instance
    start.instance = None
    start.cls = cls
    return start


class GroupDict:
    def __init__(self, groups, configs):
        self._grouplist = list(groups)
        self._groupdict = {}
        for group in groups:
            group_config = configs.get(([conf for conf in configs.keys() if
                                         group.name.lower() in conf.lower()] or [''])[0], None)
            self._groupdict[id(group)] = group, group_config

    def __getitem__(self, key):
        """
        Enables getting configuration
        with a group object or a group name.
        """
        if type(key) == int:
            val = self._groupdict.get(key, None)
            if val is None:
                raise KeyError(f"Group with id {key} not found.")
            else:
                return val[1]
        elif type(key) == str:
            values = [config for group, config in self._groupdict.values()
                      if key.lower() in group.name.lower()]
            if not values:
                raise KeyError(f"Group {key!r} not found.")
            else:
                return values[0]
        elif type(key) == Group:
            try:
                config = self[id(key)]
                return config
            except KeyError:
                raise KeyError(f"Group {key.name!r} not found.")


@singleton
class TmuxSessionManager:
    """
    Helps managing tmux sessions.
    Creates or attaches to tmux sessions based on a given configuration.
    """
    defaults = {
        'tmux-session': 'main'
    }

    def __init__(self, terminal_command):
        self._sessions = []
        self.command = terminal_command

    # TODO : end sessions
    def spawn_tmux(self, session_name):
        if not session_name in self._sessions:
            self._sessions.append(session_name)
            os.system(
                f'{self.command} \'tmux\' \'new-session\' \'-s\' \'{session_name}\'')
        else:
            os.system(
                f'{self.command} \'tmux\' \'a\' \'-t\' \'{session_name}\'')
