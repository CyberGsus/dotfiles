from custom.bindings import mod, keys
from libqtile.command import lazy
from libqtile.config import Key, Group
from libqtile.hook import subscribe




def init_groups(keys):
    groups = [Group(name, **config) for name, config in [
        ("🏠 HOME ", { 'layout' : 'max' }),
        ("⚙  DEV ", { 'layout' : 'bsp' }),
        ("📃 CLASS ", { 'layout' : 'floating' }),
        ("🔘 MEDIA ", { 'layout' : 'max' }),
        ("💲 TERM ", {'layout' : 'max'}),
    ]]

    for i in range(len(groups)):
        # Each workspace is identified by a number starting at 1
        actual_key = i + 1
        keys.extend([
            # Switch to workspace N (actual_key)
            Key([mod], str(actual_key),
                lazy.group[groups[i].name].toscreen()),
            # Send window to workspace N (actual_key)
            Key([mod, "shift"], str(actual_key),
                lazy.window.togroup(groups[i].name)),
        ])

    return groups

groups = init_groups(keys)
