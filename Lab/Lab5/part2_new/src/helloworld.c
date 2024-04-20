

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpio.h"

#define NUM_RANDOM_NUMBERS 5000


int main()
{
    init_platform();

    XGpio A_B, op_result;

    XGpio_Initialize(&A_B, XPAR_AXI_GPIO_1_DEVICE_ID);
    XGpio_Initialize(&op_result, XPAR_AXI_GPIO_0_DEVICE_ID);

    XGpio_SetDataDirection(&A_B, 1, 0);
    XGpio_SetDataDirection(&A_B, 2, 0);
    XGpio_SetDataDirection(&op_result, 1, 0);
    XGpio_SetDataDirection(&op_result, 2, 0xffff);

    printf("Start ... \n");

    int errors = 0;

    for (int i = 0; i < NUM_RANDOM_NUMBERS; i++) {
            int random_number_A = rand() / 10;
            int random_number_B = rand() / 10;
            int random_number_op = rand() % 4;
            int res, expected_result;
            XGpio_DiscreteWrite(&A_B, 1, random_number_A);
            XGpio_DiscreteWrite(&A_B, 2, random_number_B);
            XGpio_DiscreteWrite(&op_result, 1, random_number_op);

            switch(random_number_op) {
				case 0:
					expected_result = random_number_A + random_number_B;
					break;
				case 1:
					expected_result = random_number_A - random_number_B;
					break;
				case 2:
					expected_result = ~(random_number_A & random_number_B);
					break;
				case 3:
					expected_result = ~(random_number_A | random_number_B);
					break;
				default:
					expected_result = 0;
					break;
			}

            res = XGpio_DiscreteRead(&op_result, 2);

            if (res != expected_result) {
				errors++;
				printf("Error: Expected %d, Got %d, op = %d\n\r", expected_result, res, random_number_op);
			}
     }

    printf("Number of errors: %d\n\r", errors);

    cleanup_platform();
    return 0;
}
