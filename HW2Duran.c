#include	<stdint.h>

uint32_t Seed;

// Random number generator
// from Numerical Recipes
// by Press et al.

uint32_t Random(void){
	
	Seed = 1664525 * Seed + 1013904223;
	return(Seed);
}	
