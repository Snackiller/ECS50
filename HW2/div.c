#include <stdio.h>
#include <stdlib.h>
int main(int argc, char* argv[]) {
    unsigned int dividend=(unsigned int)strtoul(argv[1], 0, 10);
    unsigned int divisor=(unsigned int)strtoul(argv[2], 0, 10);
    unsigned int q=0;
    unsigned int r=0;
    for (int i=31;i>=0;i--)
    {
        r<<=1;
        r|=(dividend>>i)&1;
        if (r>=divisor)
        {
            r-=divisor;
            q|=1<<i;
        }
    }
    printf("%s / %s = %u R %u\n", argv[1], argv[2], q, r);
    return 0;
}