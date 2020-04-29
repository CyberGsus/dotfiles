from libqtile import widget
from libqtile.config import Click
from libqtile.command import lazy
from custom.theme import colors, img
from custom.bindings import get_keyboard
import os.path


def keyboard(kbd,color):
    kbd.foreground = colors['light']
    kbd.background = colors[color]
    return kbd

def battery(color):
    return widget.Battery(
            background = colors[color],
            foreground = colors['light'],
            charge_char = '\U0001F50C',
            discharge_char = '\u26a1 ',
            empty_char = '\u2620',
            full_char = '\U0001f50b',
            show_short_text = False,
            format = '{char} {percent:2.2%} {watt:.2f} W',
            update_interval = 1.5
        )

def sep(p):
    return widget.Sep(
        linewidth=0,
        padding=p,
        foreground=colors["light"],
        background=colors["dark"]
    )


def group_box():
    return widget.GroupBox(
        font="Hack Bold",
        fontsize=10,
        margin_y=0,
        margin_x=0,
        padding_y=8,
        padding_x=5,
        borderwidth=1,
        active=colors["light"],
        inactive=colors["light"],
        rounded=False,
        highlight_method="block",
        this_current_screen_border=colors["primary"],
        this_screen_border=colors["grey"],
        other_current_screen_border=colors["dark"],
        other_screen_border=colors["dark"],
        foreground=colors["light"],
        background=colors["dark"]
    )

def window_name():
    return widget.WindowName(
        font="JetBrains Bold",
        fontsize=11,
        foreground=colors["primary"],
        background=colors["dark"],
        padding=5,
        show_state = True,
    )


def systray():
    return widget.Systray(
        background=colors["dark"],
        padding=5
    )


def image(image):
    return widget.Image(
        scale=True,
        filename=img[image],
        background=colors["dark"]
    )


def text_box(s, bgcolor):
    return widget.TextBox(
        font="JetBrains Bold",
        text=s,
        padding=5,
        foreground=colors["light"],
        background=colors[bgcolor],
        fontsize=15
    )


def pacman(bgcolor):
    return widget.Pacman(
        execute="alacritty -e bash -c 'sudo ~/.scripts/upgrading.sh'",
        update_interval=10,
        foreground=colors["light"],
        background=colors[bgcolor]
    )


def net(bgcolor):
    return widget.Net(
        interface="wlp2s0",
        foreground=colors["light"],
        background=colors[bgcolor],
    )


def current_layout_icon(bgcolor):
    return widget.CurrentLayoutIcon(
        scale=0.65,
        foreground=colors["light"],
        background=colors[bgcolor],
    )


def current_layout(bgcolor):
    return widget.CurrentLayout(
        foreground=colors["light"],
        background=colors[bgcolor],
        padding=5
    )


def clock(bgcolor):
    return widget.Clock(
        foreground=colors["light"],
        background=colors[bgcolor],
        format="%a, %d of %B %Y | %T"
    )


def init_laptop_widgets():
    return [
        sep(5),
        group_box(),
        sep(5),
        window_name(),
        sep(5),
        systray(),
        sep(5),
        image("bg-to-secondary"),
        text_box(" ⟳", "secondary"),
        pacman("secondary"),
        image("primary"),
        text_box(' \u2328', 'primary'),
        keyboard(get_keyboard(), "primary"),
        image('secondary'),
        battery("secondary"),
        image("primary"),
        text_box(" ↯", "primary"),
        net("primary"),
        image("secondary"),
        current_layout_icon("secondary"),
        current_layout("secondary"),
        image("primary"),
        text_box(" 🕒", "primary"),
        clock("primary"),
        # image('secondary'),
        # text_box(' \u2328', 'secondary'),
        # widget.KeyboardLayout(
            # background = colors['secondary'][0],
            # foreground = colors['light'],
            # font = 'JetBrains Mono',
            # configured_keyboard = [ 'us', 'es' ]
            # padding = 5
        # ),
        widget.Wallpaper(
            background=colors["dark"],
            fontsize=0,
            padding=0,
            margin=0,
            wallpaper=os.path.realpath('./.config/qtile/custom/wallpapers/cyberpunk-1.jpg')
        )
    ]


def init_monitor_widgets():
    return [
        sep(5),
        group_box(),
        sep(5),
        window_name(),
        image("bg-to-secondary"),
        current_layout_icon("secondary"),
        current_layout("secondary"),
        image("primary"),
        text_box(" 🕒", "primary"),
        clock("primary")
    ]


defaults = dict(
    font='JetBrains  Mono',
    fontsize=13,
    padding=2,
)
