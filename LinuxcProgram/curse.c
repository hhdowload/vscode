#include <unistd.h>
#include <stdlib.h>
#include <curses.h>

int main()
{
    initscr();
    move(5,15);
    printw("%s","hellow world");
    refresh();

    sleep(2);

    endwin();
    exit(EXIT_SUCCESS);

}