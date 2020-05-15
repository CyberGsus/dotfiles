# Original:
#   Antonio Sarosi
#   <https://github.com/antoniosarosi/dotfiles/commit/a0d5612bc9817a063cc652428e51759ee2e8183f#diff-58df6281046aabe08e8a5974551db35a>
#   <https://github.com/antoniosarosi/dotfiles>

import sys
import os
import yaml

def change_theme(alacritty_file, theme_file):
    try:
        with open(alacritty_file) as f:
            alacritty = yaml.load(f, Loader=yaml.FullLoader)
        with open(theme_file) as f:
            theme = yaml.load(f, Loader=yaml.FullLoader)
        if "colors" in theme:
            alacritty["colors"] = theme["colors"]
        else:
            print("Theme \"{theme_file}\" has no color configuration.")

        with open(alacritty_file, 'w') as f: 
            yaml.dump(alacritty, f)

    except PermissionError as e:
        print("Can't read/write {0.filename} : Not allowed".format(e))
    except yaml.YAMLError as e:
        print("YAML error at parsing file:\n    at line {0.problem_mark.line},  column {0.problem_mark.column} :\n   {0.problem} {0.context}".format(e))
    else:
        return True
    return False


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("""Usage:
        {0[0]} <theme-yaml>""".format(sys.argv))
        exit(1)
    if not os.path.exists(sys.argv[1]):
        print("Theme file {} does not exist.".format(sys.argv[1]))
        exit(1)

    alacritty_path = os.path.join(
            ( os.environ.get("XDG_CONFIG_HOME", None) or os.path.expanduser("~/.config") ),
            "alacritty/alacritty.yml"
    )
    if ( change_theme(alacritty_path, sys.argv[1])):
        print("Theme successfully changed.")
    else:
        print("Theme could not be applied.")
    



