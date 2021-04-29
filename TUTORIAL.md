# My i3 config tutorial
I figured I'd make this mini-tutorial to explain the gist of my i3 config so people need not read through config files to understand how to use it.

## Installation
Ensure you have all the dependencies outlined in the README -- otherwise certain things won't work and may or may not show good error messages. Get X11 working, put the config in the right place (i.e. `cd ~/.config/ && git clone repourl i3`), make `i3` start with X (add `exec i3` to `~/.xinitrc`) and `startx`.

### Monitor setup
At the top of `config` there is a `set $disp1` and `set $disp2`, set those to whatever the two displays are (if you only have 1 monitor, the second one can be whatever the second monitor is named if it is connected). These names can be discovered from the `xrandr` command.

Note that this config is designed for either 1 or 2 monitor setup; more than that the combos are no longer entirely intuitive because of our use of evens and odds (but it would be pretty easy to extend to use mod 3 or mod 4). Fortunately, having a single monitor sometimes and two other times is fine--all of the commands don't need to be changed to work with two monitors *because* they are based on even/odd.

## Usage

### Basic Application Management
Everything in this setup revolves around `Super` or `Windows` key; if you use keyboard bindings on windows, this concept won't be too foreign--in fact, some of the windows accelerators work here; including
- `Super + E`: Launch explorer
- `Super + R`: Run uses rofi to enable text search for application you're looking for.
- `Ctrl + Shift + Esc`: Launch task manager
- `Alt + PrtScr`: Take a fullscreen screenshot
- `Ctrl + PrtScr`: Take a screenshot of window
- `Shift + PrtScr`: Take a screenshot with rectangle (you select with your mouse)

But there are **plenty** more to make your life easier--never again will you need to use your mouse to launch anything. Once you start getting use to the bindings, it becomes very natural. Nonetheless, each letter is related to what it does for mnemonic purposes.
- `Super + T`: Open a Terminal
- `Super + W`: Open a web browser
- `Super + V`: Open a VS Code (the best text editor)
- `Super + O`: Launch LibreOffice
- `Super + N`: Launch a jupyter notebook because why not
- `Super + B`: Launch Baka-MPlayer (my media player)
- `Super + C`: Launch Clementine (my music player)
- `Super + Ctrl + V`: "Sudo" paste--when applications don't support paste :P (hint: we type it for you)

Also very conveniently--`context_aware_dir` detects directories in the window title and uses them when launching directory-aware applications. What this means is that when we're looking at a File Explorer directory, and we use `Super + T`, the terminal opens up **in that directory**; furthermore, the other way around works as well. Never again will you have to keep navigating through directories when you're already there! If you don't want that to happen, just add an extra `Shift`: `Super + Shift + T` will open up a terminal at the default location `~`.

You'll notice these are very close to the left so you don't need to stretch your fingers very much to open **very common things**. The idea of using an extra key like `Shift` as a modifier is used a lot to make things pretty intuitive for getting started.

We also have a few window controlling functions also close:
- `Super + F`: Find your lost window
- `Super + Z`: Toggle the Z axis of your program (float or tile)
- `Super + Q`: Quit an application
- `Super + Ctrl + Q`: Quit your computer: menu for logging out, suspend, reboot, or shutdown
- `Super + Ctrl + X`: Exit i3 (closes x server)

### Tiling layout mouse management
i3 is a tiling layout manager meaning your windows automatically lay themselves out--never again will you lose your windows behind a bunch of others. This utilizes all your screen real estate all the time; but also means if you want to open a bunch of things you'll need more space. Hence `workspaces` are used a lot--you don't minimize, you just move to a new workspace if you don't have enough space. Some applications *should just float*, like a media player; in those cases, you can toggle floating mode of a window with `Super + Z` or you can hold `Super` and middle click the window to do the same. You can drag it around by holding `Super` when you left click to move it. You can resize both floating windows and tiled windows by holding `Super` and right click dragging. This works anywhere near the edge of a window--you need not struggle to get to the edge of your window for resizing.

Once you get used to this, your left hand stays by `Super` and your right on the mouse; together it is easy to manipulate the position of your windows and more as you'll see next.

### Tiling layout keyboard management
As much as possible, i3 and this config are designed to make your mouse less of a requirement and more of a convenience when you want it. This is because the keyboard is much faster and more precise--this config allows you to, in a few keystrokes, start any application you want, quit it, move it around, split it and more.

#### Moving around relatively
With several applications open, you can move your focused application with the arrow keys `Super + Up|Down|Left|Right`; you can also move the application by having it focused and then using `Super + Shift + Up|Down|Left|Right`. Intuitively you hold the `Shift` key to hold the window as you move with the window. Try it out and get a feel for how it works, by moving you may end up re-laying out other windows around it. You can also move across monitor-aware workspaces with the `Alt` modifier; that-is `Super + Alt + Left|Right` will move you to the workspace on the other monitor (with a wrap-around), and `Super + Alt + Up|Down` will move you to the next workspace (i.e. in/out) on the given monitor. Following similar logic of before, `Super + Shift + Alt + Up|Down|Left|Right` brings the currently focused window with you.

#### Moving around absolutely
If you know where you want to go (based on the numbers shown next to the workspaces), you can go there immediately with `Super + 1-10` where `10` uses the key `0` because it's the last number on the keyboard (they get harder to hit with just your left hand as they get bigger, that's why we didn't start at 0). Again you can take a window with you with a `Shift` modifier. `Super + Shift + 1-10`. You can relatively move workspaces past 10 but the config is really not designed for that many workspaces and the even/odd display assignments fall apart; feel free to add more if you need this.

#### Manipulating layouts
i3 has some powerful layout mechanisms enabling you to split windows vertically, horizontally, create tabs or stack windows which take getting used to. In my experience tabs and stacking are not often useful since most applications where tabbing makes sense handle it themselves. This takes a bit to get used to, but you can play around with it to get used to it.

- `Super + Ctrl + Down`: Create a vertical split layout (new windows will spawn vertically below the window within the frame of the old window)
- `Super + Ctrl + Right`: Create a horizontal split layout (new windows will spawn horizontally to the right within the frame of the old window)
- `Super + Ctrl + Up`: Switch the current layout mode (e.g. horizontal split) into a vertical mode
- `Super + Ctrl + Left`: Switch the current layout mode (e.g. vertical split) into a horizontal mode

Less useful:
- `Super + Ctrl + Tab`: Switch the current layout mode to a tab layout
- `Super + Ctrl + s`: Switch the current layout mode to a stacked layout

Note that we don't have ways to create tab / stack layouts--mainly because they aren't used very often, if you create a new layout group (i.e. with `Super + Ctrl + Down`) you can then transform it into the layout afterwards to achieve the same effect as creating a tab/stack layout.

That the "create" operations occur on children as well, this is why you can't convert with the same binding. You end up constructing a tree of windows and layouts, this can be confusing at the beginning, and more-so in the next part; but know that you can usually simply move windows out of the groups with `Super + Shift + Up|Down|Left|Right`. 

Going down/up the layout tree is a bit difficult to think about and a bit easier to experiment with but it can be done with:
- `Super + Home`: Focus outwards on the parent layout
- `Super + End`: Focus inwards on the child layout

This is useful for modifying the group layout or moving an entire group of windows in a shared layout. For instance, you can move all the windows in a workspace to the next monitor by pressing `Super + Home` until all windows are highlighted (the workspace primary layout is focused) and then pressing `Super + Alt + Shift + Left|Right` to move them over to the other monitor.

In general you can get away with not being able to do this, but it is pretty powerful and convenient once you get used to it.

## Development
Once you get used to the basics--if you like it, you may want to further customize this config to better serve you. Modifying the config at real-time is pretty convenient--you can reload i3 with `Super + Ctrl + C` after modifying the config or restart with `Super + Ctrl + R`. Below is some information for directing you on how to make specific modifications.

- config: calls everything else, this is i3's config file format and should be in the place i3 expects it `~/.config/i3`
- /blocks/*: [i3blocks](https://github.com/vivien/i3blocks) these are mini scripts for displaying blocks on the i3 bar.
- /scripts/*: Accompanying shell/python scripts for enabling i3 operations, many utilize `i3-msg` or `i3ipc` for interacting with i3
- /settings/*: extra configuration files whether they be preparing the script environment variables, i3blocks configuration, or rofi

### Adding a key-binding
Find `Custom Application Key Bindings` in `config`, see the format there and use it to add your own. i.e.

```
bindsym $super+y exec --no-startup-id yourprogram
```

If you want to tie into `context_aware_dir` as described above, see how the others do it, just ensure the workdir is `$($conf/scripts/context_aware_dir.sh)`

### Adding an application on startup
We piggy-back off of the same mechanism other desktops use which provides nice desktop integration with applications that have their own "start this at startup" functionality. All of the core daemons are stored in settings/autostart using the free desktop specification and can be included in the user-local autostart with `ln -s $HOME/.config/i3/settings/autostart $HOME/.config/autostart/i3`, effectively adding these daemons to your standard autostart configuration. Any application registered in `$HOME/.config/autostart`, as with other desktop environments, will be autostarted.

### Adding icons for your own applications
We use the `settings/icons.json` file; finding the name on the left can be done with `xprop` on the command line, after executing click the window and look for `WM_CLASS(string)`. The name on the right depends on whatever the [python fontawesome](https://github.com/justbuchanan/fontawesome-python) module thinks; these change once in a while; I typically just open up `ipython`, `import fontawesome` and look for a name in `fontawesome.icons`.

### Ensure your application always starts floating
Find `Custom Window Layouts` and add your application. The `class` can be found same as above by using `xprop`.


### Attaching a new monitor
Frankly this branch is for my desktop layout which typically doesn't get a new monitor, my laptop branch doesn't have unique documentation but you can get the script from the laptop branch `scripts/monitor.sh`. I just run the script to get things displayed on the new monitor, and then use my commands like I would on my desktop. It makes sense for this to be attached to a keybinding, on the laptop branch, it is--to `$super+d`.


## Conclusion
The sky is the limit with i3, I've been using this layout for years with little modification, besides keeping up with tooling changes, and find it extraordinarily convenient. I hope this helps someone experience the joy of having a ui environment that works with you instead of against you, and hope this config gets you off the ground with building your own personalized environment. The only problem is every other environment I use now feels much much worse.
