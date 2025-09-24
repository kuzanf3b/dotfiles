/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx     = 3;  /* border pixel of windows */
static const unsigned int snap         = 32; /* snap pixel */
static const int showbar               = 1;  /* 0 means no bar */
static const int topbar                = 1;  /* 0 means bottom bar */
static const char *fonts[]             = { "DroidSansM Nerd Font:size=12" };
static const char dmenufont[]          = "monospace:size=10";

/* Nord colors */
static const char col_bg[]    = "#2E3440"; /* background */
static const char col_fg[]    = "#D8DEE9"; /* foreground */
static const char col_blk[]   = "#3B4252"; /* black (normal) */
static const char col_red[]   = "#BF616A"; /* red */
static const char col_grn[]   = "#A3BE8C"; /* green */
static const char col_ylw[]   = "#EBCB8B"; /* yellow */
static const char col_blu[]   = "#81A1C1"; /* blue */
static const char col_mag[]   = "#B48EAD"; /* magenta */
static const char col_cyn[]   = "#88C0D0"; /* cyan */
static const char col_brblk[] = "#4C566A"; /* bright black */

static const char *colors[][3] = {
	/*               fg      bg      border */
	[SchemeNorm] = { col_fg, col_bg, col_brblk },
	[SchemeSel]  = { col_blu, col_bg, col_cyn },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* rules */
static const Rule rules[] = {
	/* class          instance  title  tags mask  isfloating  monitor */
	{ "Gimp",         NULL,     NULL,  0,         1,          -1 },
	{ "Brave-browser",NULL,     NULL,  1 << 2,    0,          -1 },
	{ "firefox",      NULL,     NULL,  1 << 1,    0,          -1 },
	{ "zen",          NULL,     NULL,  1 << 1,    0,          -1 },
	{ "discord",      NULL,     NULL,  1 << 4,    0,          -1 },
	{ "code",         NULL,     NULL,  1 << 5,    0,          -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;    /* 1 will force focus on the fullscreen window */
static const int refreshrate    = 144;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=", tile },    /* first entry is default */
	{ "><>", NULL },    /* floating */
	{ "[M]", monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG) \
	{ MODKEY,                       KEY, view,       { .ui = 1 << TAG } }, \
	{ MODKEY|ControlMask,           KEY, toggleview, { .ui = 1 << TAG } }, \
	{ MODKEY|ShiftMask,             KEY, tag,        { .ui = 1 << TAG } }, \
	{ MODKEY|ControlMask|ShiftMask, KEY, toggletag,  { .ui = 1 << TAG } },

/* helper */
#define SHCMD(cmd) { .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0";
static const char *dmenucmd[] = {
	"dmenu_run", "-m", dmenumon, "-fn", dmenufont,
	"-nb", col_bg, "-nf", col_fg,
	"-sb", col_cyn, "-sf", col_bg,
	NULL
};

static const char *termcmd[] = {
	"alacritty", "--config-file",
	"/home/kuzan/.config/alacritty/alacritty-dwm.toml",
	NULL
};

static const char *screenshot_select_cmd[] = {
	"/bin/sh", "-c",
	"maim -s | tee ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png | xclip -selection clipboard -t image/png",
	NULL
};

static const char *screenshot_full_cmd[] = {
	"/bin/sh", "-c",
	"maim | tee ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png | xclip -selection clipboard -t image/png",
	NULL
};

/* keys */
static const Key keys[] = {
	{ MODKEY,             XK_d,      spawn,          { .v = dmenucmd } },
	{ MODKEY,             XK_Return, spawn,          { .v = termcmd } },
  { 0,                  XK_Print,  spawn,          {.v = screenshot_select_cmd } },
  { MODKEY,             XK_Print,  spawn,          {.v = screenshot_full_cmd } },
	{ MODKEY,             XK_b,      togglebar,      { 0 } },
	{ MODKEY,             XK_j,      focusstack,     { .i = +1 } },
	{ MODKEY,             XK_k,      focusstack,     { .i = -1 } },
	{ MODKEY,             XK_i,      incnmaster,     { .i = +1 } },
	{ MODKEY,             XK_p,      incnmaster,     { .i = -1 } },
	{ MODKEY,             XK_h,      setmfact,       { .f = -0.05 } },
	{ MODKEY,             XK_l,      setmfact,       { .f = +0.05 } },
	{ MODKEY,             XK_z,      zoom,           { 0 } },
	{ MODKEY,             XK_Tab,    view,           { 0 } },
	{ MODKEY,             XK_q,      killclient,     { 0 } },
	{ MODKEY,             XK_t,      setlayout,      { .v = &layouts[0] } },
	{ MODKEY,             XK_f,      setlayout,      { .v = &layouts[1] } },
	{ MODKEY,             XK_m,      setlayout,      { .v = &layouts[2] } },
	{ MODKEY,             XK_space,  setlayout,      { 0 } },
	{ MODKEY|ShiftMask,   XK_space,  togglefloating, { 0 } },
	{ MODKEY|ShiftMask,   XK_l,      spawn,          SHCMD("slock") },
	{ MODKEY,             XK_0,      view,           { .ui = ~0 } },
	{ MODKEY|ShiftMask,   XK_0,      tag,            { .ui = ~0 } },
	{ MODKEY,             XK_comma,  focusmon,       { .i = -1 } },
	{ MODKEY,             XK_period, focusmon,       { .i = +1 } },
	{ MODKEY|ShiftMask,   XK_comma,  tagmon,         { .i = -1 } },
	{ MODKEY|ShiftMask,   XK_period, tagmon,         { .i = +1 } },
	TAGKEYS(              XK_1,                      0 )
	TAGKEYS(              XK_2,                      1 )
	TAGKEYS(              XK_3,                      2 )
	TAGKEYS(              XK_4,                      3 )
	TAGKEYS(              XK_5,                      4 )
	TAGKEYS(              XK_6,                      5 )
	TAGKEYS(              XK_7,                      6 )
	TAGKEYS(              XK_8,                      7 )
	TAGKEYS(              XK_9,                      8 )
	{ MODKEY|ShiftMask,   XK_q,      quit,           { 0 } },
};

/* buttons */
static const Button buttons[] = {
	{ ClkLtSymbol,   0,              Button1, setlayout,      { 0 } },
	{ ClkLtSymbol,   0,              Button3, setlayout,      { .v = &layouts[2] } },
	{ ClkWinTitle,   0,              Button2, zoom,           { 0 } },
	{ ClkStatusText, 0,              Button2, spawn,          { .v = termcmd } },
	{ ClkClientWin,  MODKEY,         Button1, movemouse,      { 0 } },
	{ ClkClientWin,  MODKEY,         Button2, togglefloating, { 0 } },
	{ ClkClientWin,  MODKEY,         Button3, resizemouse,    { 0 } },
	{ ClkTagBar,     0,              Button1, view,           { 0 } },
	{ ClkTagBar,     0,              Button3, toggleview,     { 0 } },
	{ ClkTagBar,     MODKEY,         Button1, tag,            { 0 } },
	{ ClkTagBar,     MODKEY,         Button3, toggletag,      { 0 } },
};
