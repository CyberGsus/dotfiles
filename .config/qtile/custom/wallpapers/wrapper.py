from libqtile.widget.wallpaper import Wallpaper
import asyncio


async def async_call(cmd):
    if type(cmd) in (list, tuple):
        cmd = ' '.join(cmd)
    if type(cmd) != str:
        raise TypeError(f'Expected list,tuple or str, got instead {type(cmd).__name__!r}')
    try:
        (await asyncio.create_subprocess_shell(cmd)).communicate()
    except:
        pass

def run_coroutine(coro):
    try:
        loop = asyncio.get_event_loop()
    except RuntimeError:
        loop = asyncio.new_event_loop()
    loop.run_until_complete(coro)

class ExtendedWallpaper(Wallpaper):
    """
    Extends the Wallpaper class in order
    to be able to call certain functions with ease
    """
    def next_wallpaper(self):
        self.index += 1
        self.index %= len(self.images)
        self.set_wallpaper()

class AsyncWallpaper(ExtendedWallpaper):
    """
    Like original qtile Wallpaper, but makes subprocess call
    async if a wallpaper_command is used. Useful for making
    transitions without the need to worry about locking qtile.
    """


    # Override
    def set_wallpaper(self):
        ### Copied this from original as needed
        if len(self.images) == 0:
            if self.wallpaper is None:
                self.text = "empty"
                return
            else:
                self.images.append(self.wallpaper)
        cur_image = self.images[self.index]
        if self.label is None:
            self.text = os.path.basename(cur_image)
        else:
            self.text = self.label
        if not self.wallpaper_command: # Inverted logic in order to pack
            # everything inside a block
            self.qtile.paint_screen(self.bar.screen, cur_image, self.option)

        else:
            self.wallpaper_command.append(cur_image)
            ### Next lines are mine

            run_coroutine(async_call(self.wallpaper_command))

            # Again copy of superclass
            self.wallpaper_command.pop()
