from libqtile.command import lazy
from libqtile import hook
from libqtile.config import Group
import os


def next_keyboard_layout(keyboard):
    @lazy.function
    def __inner(qtile_session):
        keyboard = __inner.__getattribute__('keyboard')
        if keyboard is not None:
            keyboard.cmd_next_keyboard()
        else:
            qtile_session.restart()
    __inner.keyboard = keyboard
    return __inner

@lazy.function
def quit_qtile(qtile_session):
    try:
        # os.system('tmux kill-server')
        pass
    finally:
        lazy.shutdown()


def singleton(cls):
    def start(*args, **kwargs):
        if not start.instance:
            start.instance = start.cls(*args, **kwargs)
        return start.instance
    start.instance = None
    start.cls = cls
    return start


@singleton
class TmuxSessionManager:
    """
    Helps managing tmux sessions.
    Creates or attaches to tmux sessions based on a given configuration.
    """
    defaults = {
            'tmux-session' : 'main'
        }

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




    def __init__(self, terminal_command, groups, **group_config):
        self._groups = TmuxSessionManager.GroupDict(groups, group_config)
        self._sessions = []
        self.command = terminal_commnad

    # TODO : end sessions
    def spawn_tmux(self, current_group):
        session_name = self._groups.get(current_group, self.defaults).get(
                'tmux-session', self.defaults['tmux-session'])
        if not session_name in self._sessions:
            self._sessions.append(session_name)
            os.system(f'{self.command} \'tmux\' \'new-session\' \'-s\' \'{session_name}\'')
        else:
            os.system(f'{self.command} \'tmux\' \'a\' \'-t\' \'{session_name}\'')




