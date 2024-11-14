// Author: Tomas Baublys
// substr function demo in c99 for Computer Architecture course

#include <stdio.h>
#include <stdlib.h>

char *substr(char *str, char *substr_keyword);

int main(void) {
    char *str = "I calculated Pi and it`s s`ti dna iP detaluclac I";
    char *substr_keyword = "Pi";

    char *newstr = substr(str, substr_keyword);

    if(newstr) {
        printf("%s\n", newstr);
    }

    return 0;
}

// returns a pointer to the location of the start of the substring in the provide char *str argument, if not found return NULL
char *substr(char *str, char *substr_keyword) {
    if(!str || !substr_keyword) {
        return NULL;
    }

    while(*str != '\0') {
        if(*str == *substr_keyword) {
            char *curr_str_pointer = str;
            char *substr_keyword_copy = substr_keyword;

            while(1) {
                if(*curr_str_pointer == '\0') {
                    return NULL;
                }

                if(*substr_keyword_copy == '\0') {
                    return str;
                }

                if(*curr_str_pointer != *substr_keyword_copy) {
                    ++str;
                    break;
                }

                ++curr_str_pointer;
                ++substr_keyword_copy;
            }
        }
        ++str;
    }

    return NULL;
}

