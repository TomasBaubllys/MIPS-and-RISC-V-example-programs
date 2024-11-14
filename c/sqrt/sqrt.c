#include<stdio.h>
#include<stdlib.h>

#define ITERATIONS 40			// number of iterations for the algorithm
#define INITIAL_GUESS 1			// initial guess for the algorithm

float newtons_sqrt(float num) {
	if(num < 0) {
		return 0;
	}

	float x = INITIAL_GUESS;
	
	for(int i = 0; i < ITERATIONS; ++i) {
		x = (x + num / x) / 2; 
	}

	return x;

}


int main(void) {
	float number = 0;

	printf("Enter the number to calculate the square root of: ");
	if(scanf("%f", &number) != 1) {
		fprintf(stderr, "incorrect input!");
		return 0;
	}

	printf("Result: %f\n", newtons_sqrt(number));

	return 0;
}
