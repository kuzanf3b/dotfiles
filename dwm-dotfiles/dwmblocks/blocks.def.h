// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
static const Block blocks[] = {
    /*Icon*/ /*Command*/ /*Interval*/ /*Signal*/
    {"", "/home/kuzan/.local/bin/song.sh", 1, 5},
    {"", "/home/kuzan/.local/bin/cpu.sh", 1, 3},
    {"", "/home/kuzan/.local/bin/battery.sh", 15, 2},
    {"", "/home/kuzan/.local/bin/audio.sh", 1, 4},
    {"", "/home/kuzan/.local/bin/date.sh", 60, 1},
    // padding block supaya status nggak nabrak systray
    {"", "echo ''", 0, 0},
};

// sets delimiter between status commands. NULL character ('\0') means no
// delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
