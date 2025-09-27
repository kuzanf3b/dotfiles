/* user and group to drop privileges to */
static const char *user = "kuzan";
static const char *group = "kuzan";

static const char *colorname[NUMCOLS] = {
    [INIT] = "#1A1B26",   /* after initialization */
    [INPUT] = "#C0CAF5",  /* during input */
    [FAILED] = "#FF9E64", /* wrong password */
    [CAPS] = "#F7768E",   /* CapsLock on */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime = 5;
