from libqtile.command import lazy
from libqtile import hook
from libqtile.config import Group
from custom.extra import TmuxSessionManager
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


@hook.subscribe.addgroup
def on_group_add(qtile, group):
    groups = globals().get('groups', None)
    if groups is None:
        groups = []
        globals()['groups'] = groups
    groups.append(group)


def start_tmux(command, groups, group_config):
    @lazy.function
    def start_tmux(qtile):
        start_tmux.session_manager.spawn_tmux(qtile)

    start_tmux.session_manager = TmuxSessionManager(
            command,
            groups,
            **group_config)
    return start_tmux

