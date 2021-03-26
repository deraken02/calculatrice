#include <stdio.h>
#include <inttypes.h>

/*
 *Additionne les deux paramètre
 */
int64_t addition(int64_t a,int64_t b){
  return (a+b);
}

/*
 *Soustrait le premier paramètre par le second
 */
int64_t soustraction(int64_t a,int64_t b){
  return (a-b);
}

/*
 *Divise le premier paramètre par le second
 */
int64_t division(int64_t a,int64_t b){
  return (a/b);
}

/*
 *Multiplie les deux paramètre
 */
int64_t multiplication(int64_t a,int64_t b){
  return (a*b);
}

/*
 *Imprime le paramètre 
 */
void imprime(int64_t a){
  printf("%ld\n",a);
}
