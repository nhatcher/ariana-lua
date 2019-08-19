 
#include <stdio.h>
#include "cephes.h"

int main() {
  printf("j0(3) = %f\n ", cephes_j0(3));
  return 0;
}

// gcc test.c cephes/cephes.so -o test -Lcephes -Icephes -lm
