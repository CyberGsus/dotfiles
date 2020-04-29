from custom.bindings import mod, keys
from libqtile.command import lazy
from libqtile.config import Key, Group
from libqtile.hook import subscribe


def change_group(name):
    def __inner(qtile):
        qtile.current_screen.set_group(lazy.group[__inner.name])
    __inner.name = name
    return lazy.function(__inner)


def init_groups(keys):
    groups = [Group(name, **config) for name, config in [
        ("\U0001f3e0 HOME ", { 'layout' : 'max' }),
        ("\u2699  DEV ", { 'layout' : 'bsp' }),
        ("\U0001f4c3 CLASS ", { 'layout' : 'floating' }),
        ("\U0001f518 MEDIA ", { 'layout' : 'max' }),
        ("\U0001f4b2 TERM ", {'layout' : 'max'}),
    ]]

    for i in range(len(groups)):
        # Each workspace is identified by a number starting at 1
        actual_key = i + 1
        keys.extend([
            # Switch to workspace N (actual_key)
            Key([mod], str(actual_key),
                lazy.group[groups[i].name].toscreen()),
                # change_group(groups[i].name)),
            # Send window to workspace N (actual_key)
            Key([mod, "shift"], str(actual_key),
                lazy.window.togroup(groups[i].name)),
        ])

    return groups

groups = init_groups(keys)


