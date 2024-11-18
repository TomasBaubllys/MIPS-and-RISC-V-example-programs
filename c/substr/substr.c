// Author: Tomas Baublys
// substr function demo in c99 for Computer Architecture course

#include <stdio.h>
#include <stdlib.h>

#define MAX_INPUT 64

char *substr(char *str, char *substr_keyword);

int main(void) {
    char str[MAX_INPUT];
    char substr_keyword[MAX_INPUT];

    printf("Welcome to substring algorithm in C enter a string:\n");
    scanf("%63s\n", str);

    printf("Enter the substring keyword:\n");
    scanf("%63s\n", substr_keyword);

    char *newstr = substr(str, substr_keyword);

    if(newstr) {
        printf("Result: %s\n", newstr);
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

