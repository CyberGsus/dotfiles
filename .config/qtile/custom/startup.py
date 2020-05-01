from libqtile.command import lazy
from libqtile.hook import subscribe
from libqtile.config import Key
from custom.bindings import keys, special_keys, mod
from custom.groups import groups

current_special = None


@subscribe.layout_change
def layout_change(layout, group):
    # Remove last keybindings
    current_special = globals().get('current_special', None)
    keys = globals().get('keys', None)
    if current_special is not None:
        for key in current_special:
            keys.remove(key)

    # Add special keybindings
    if layout.name in special_keys and keys is not None:
        current_special = special_keys[layout.name]
        keys.extend(current_special)
    keys = list(set(keys)) # Remove duplicates

