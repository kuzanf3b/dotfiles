// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.

static const Block blocks[] = {
    /* Icon  | Command                                                        |
       Interval | Signal */
    {"", "/home/kuzan/dotfiles/dwm-dotfiles/dwmblocks/scripts/song.sh", 1, 5},
    {"", "/home/kuzan/dotfiles/dwm-dotfiles/dwmblocks/scripts/cpu.sh", 1, 3},
    {"", "/home/kuzan/dotfiles/dwm-dotfiles/dwmblocks/scripts/battery.sh", 15,
     2},
    {"", "/home/kuzan/dotfiles/dwm-dotfiles/dwmblocks/scripts/audio.sh", 0, 4},
    {"", "/home/kuzan/dotfiles/dwm-dotfiles/dwmblocks/scripts/date.sh", 60, 1},

    // padding block supaya status nggak nabrak systray
    {"", "echo ''", 0, 0},
};

// sets delimiter between status commands.
// NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
