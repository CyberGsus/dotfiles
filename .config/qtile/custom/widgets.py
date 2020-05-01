from custom.bindings import get_keyboard
from custom.coloring import apply_alpha_qtile
from custom.theme import colors, img
from libqtile import widget
from libqtile.command import lazy
from libqtile.config import Click
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
        fontsize=11,
        margin_y=0,
        margin_x=0,
        padding_y=6,
        padding_x=0,
        borderwidth=3.5,
        active=colors["light"],
        inactive=colors["light"],
        rounded=False,
        highlight_method="line",
        this_current_screen_border=colors["primary"],
        this_screen_border=colors["grey"],
        other_current_screen_border=colors["dark"],
        other_screen_border=colors["dark"],
        foreground=colors["light"],
        background=colors["dark"],
        highlight_color = apply_alpha_qtile(colors["dark"], colors["light"], 0.15),
        font=defaults['font_alt'],
    )

def window_name():
    return widget.WindowName(
        foreground=colors["primary"],
        background=colors["dark"],
        show_state = True,
        fontsize=defaults['fontsize'],
        font=defaults['font_alt']
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
        text=s,
        foreground=colors["light"],
        background=colors[bgcolor],
        **defaults
    )


def pacman(bgcolor):
    return widget.Pacman(
        execute="alacritty -e bash -c '~/.scripts/upgrading.sh'",
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
        format="%a %B %d %Y [ %T ]"
    )


def init_laptop_widgets():
    return [
        sep(7),
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
        image('secondary'),
        widget.Wallpaper(
            background=colors["secondary"],
            foreground=colors['light'],
            fontsize=11,
            padding=3,
            margin=0,
            directory=os.path.expanduser('~/.config/qtile/custom/wallpapers/'),
            label='Wallpaper'
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
    font='JetBrains Mono',
    font_alt='IBMPlexMono, Bold Italic',
    fontsize=12,
    padding=2,
)
