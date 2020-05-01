from libqtile.command import lazy
from itertools import cycle
from os import system
from subprocess import check_output
from contextlib import redirect_stdout

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
        if not self.available: return
        with redirect_stdout(self.devnull):
            os.system('redshift -x')

    @lazy.function
    def next(self, qtile):
        # TODO : add command options
        if not self.available: return
        self.current_value = next(self.cycle)
        with redirect_stdout(self.devnull):
            os.system(f'redshift -PO  {self.current_value}')
        print(
f"""\x1b[1;38;5;118m[RedShift] \x1b[0;38;5;118mChanged value to '{self.current_value}'\x1b[m'""")

    def __del__(self):
        print("[RedShift] Shutting down...")
        if not self.devnull.closed: self.devnull.close()


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
            group_config = configs.get(([ conf for conf in configs.keys() if
                group.name.lower() in conf.lower()] or [''])[0], None)
            self._groupdict[id(group)] = group, group_config

    def __getitem__(self, key):
        """
        Enables getting configuration
        with a group object or a group name.
        """
        if type(key) == int:
            val = self._groupdict.get(key, None)
            if val is None: raise KeyError(f"Group with id {key} not found.")
            else: return val[1]
        elif type(key) == str:
            values = [ config for group, config in self._groupdict.values()
                    if key.lower() in group.name.lower() ]
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
            'tmux-session' : 'main'
    }

    def __init__(self, terminal_command, groups, group_config):
        self._groups = GroupDict(groups, group_config)
        self._sessions = []
        self.command = terminal_commnad

    # TODO : end sessions
    def spawn_tmux(self, qtile):
        session_name = self._groups.get(qtile.current_group, self.defaults).get(
                'tmux-session', self.defaults['tmux-session'])
        if not session_name in self._sessions:
            self._sessions.append(session_name)
            os.system(f'{self.command} \'tmux\' \'new-session\' \'-s\' \'{session_name}\'')
        else:
            os.system(f'{self.command} \'tmux\' \'a\' \'-t\' \'{session_name}\'')
