from libqtile.config import Screen
from libqtile import bar

from custom.widgets import init_laptop_widgets, init_monitor_widgets
import subprocess


def init_screens():
    screens = [
        Screen(
            top=bar.Bar(
                init_laptop_widgets(),
                24,
                opacity=0.85
            )
        )
    ]

    # Check if HMDI is plugged in, if so initialize another screen
    check_hdmi = "xrandr | awk '/\sconnected/ && /HDMI/ {print $1}'"
    if (subprocess.getoutput(check_hdmi) == "HDMI-1"):
        screens.append(
            Screen(
                top=bar.Bar(
                    init_monitor_widgets(),
                    24,
                    opacity=0.85
                )
            )
        )

    return screens
