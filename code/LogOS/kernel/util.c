#include "util.h"

void reverse(char *str, int len) {
	int i;
	for(i = 0; i < len / 2; i++) {
		str[i] ^= str[len-i-1];
		str[len-i-1] ^= str[i];
		str[i] ^= str[len-i-1];
	}
}

void memory_copy(char *source, char *dest, int nbytes) {
	int i;
	for(i = 0; i < nbytes; i++)
		*(dest + i) = *(source + i);
}

void memory_set(u8 *dest, u8 val, u32 len) {
	u8 *temp = (u8*)dest;
	for(;len != 0;len--) *temp++ = val;
}

void int_to_ascii(int n, char str[]) {
	int i, sign;
	if((sign = n) < 0) n = -n;
	i = 0;
	do {
		str[i++] = n % 10 + '0';
	} while ((n /= 10) > 0);

	if(sign < 0) str[i++] = '-';
	str[i]= '\0';

	reverse(str, i);
}
