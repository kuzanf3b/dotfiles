/* user and group to drop privileges to */
static const char *user = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
    [BACKGROUND] = "#2E3440", /* after initialization */
    [INIT] = "#4C566A",       /* after initialization */
    [INPUT] = "#81A1C1",      /* Nord blue for input */
    [FAILED] = "#BF616A",     /* Nord red for wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime = 10;

/* insert grid pattern with scale 1:1, the size can be changed with logosize */
static const int logosize = 100;
static const int logow =
    12; /* grid width and height for right center alignment*/
static const int logoh = 6;

static XRectangle rectangles[9] = {
    /* x    y   w   h */
    {0, 3, 1, 3}, {1, 3, 2, 1}, {0, 5, 8, 1}, {3, 0, 1, 5},  {5, 3, 1, 2},
    {7, 3, 1, 2}, {8, 3, 4, 1}, {9, 4, 1, 2}, {11, 4, 1, 2},

};
