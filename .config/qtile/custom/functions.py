from libqtile.command import lazy


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

# keys.extend([
#     Key([mod, alt], 'space', next_keyboard_layout)
# ])
