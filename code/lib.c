#include <stdio.h>

extern int printHex(int);
extern int getStr(char*, int);
extern int printStr(char*,int);
extern int createFile(char*);
extern int deleteFile(char*);
extern int appendToFile(char*,char*,int);
extern int writeToFile(char*,char*,int);

#define	OK	0
#define	NO_INPUT	1
#define	TOO_LONG	2

// Print a given integer in hex form, helpful for debugging
int printHex(int a) {
	printf("0x%08X\n", a);
	return 0;
}

// Safe input method
static int getLine(char* buff, int size) {
	int ch, extra;
	fflush(stdout);
	int broken = 1;
	for(int i = 0; i < size; i++) {
		ch = getchar();
		if(ch == EOF || ch == '\n') {
			if(i == 0)
				return NO_INPUT;
			broken = 0;
			break;
		}
		else
			buff[i] = ch;
	}
	if(broken == 1){
		while((getchar()) != '\n');
		return TOO_LONG;
	}
	return OK;
}

// Getting input
int getStr(char* buffer, int max_length) {
	return getLine(buffer, max_length);
}

// Writing Strings with defined length
int printStr(char* message, int length) {
	printf("%.*s\n", length, message);
	return 0;
}

// Creating an empty file
int createFile(char* filename) {
	FILE* fp;
	fp = fopen(filename, "a+");
	if(fp == NULL)
		return 1;
	fclose(fp);
	return 0;
}

// Appending to a file
int appendToFile(char* filename, char* buffer, int length) {
	FILE* fp;
	fp = fopen(filename, "a+");
	if(fp == NULL)
		return 1;
	fprintf(fp, "%.*s\n", length, buffer);
	fclose(fp);
	return 0;
}

// Clearing and writing to a file
int writeToFile(char* filename, char* buffer, int length) {
	FILE* fp;
	fp = fopen(filename, "w+");
	if(fp == NULL)
		return 1;
	fprintf(fp, "%.*s\n", length, buffer);
	fclose(fp);
	return 0;
}

// Removing a file
int deleteFile(char* filename) {
	return remove(filename);
}
