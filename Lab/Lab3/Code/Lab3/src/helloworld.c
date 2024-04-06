/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

/*
#include <stdio.h>
#include <xparameters.h>
#include <xgpio.h>

XGpio LED;
XGpio Switches;
int switches_state;


int main()
{

    init_platform();

	XGpio_Initialize(&LED, XPAR_LEDS_8BITS_DEVICE_ID);
	XGpio_Initialize(&Switches, XPAR_DIP_SWITCHES_8BITS_DEVICE_ID);

	XGpio_SetDataDirection(&LED, 1, 0x0);
	XGpio_SetDataDirection(&Switches, 1, 0xffffffff);

	while(1)
	{
		switches_state = XGpio_DiscreteRead(&Switches, 1);
		XGpio_DiscreteWrite(&LED, 1, switches_state);
	}

    return 0;
}*/


// summation

#include <stdio.h>
#include <xparameters.h>
#include <xgpio.h>

XGpio LED;
XGpio Switches;
int switches_state;


int main()
{

    init_platform();

	XGpio_Initialize(&LED, XPAR_LEDS_8BITS_DEVICE_ID);
	XGpio_Initialize(&Switches, XPAR_DIP_SWITCHES_8BITS_DEVICE_ID);

	XGpio_SetDataDirection(&LED, 1, 0x0);
	XGpio_SetDataDirection(&Switches, 1, 0xffffffff);

	while(1)
	{
		switches_state = XGpio_DiscreteRead(&Switches, 1);
		XGpio_DiscreteWrite(&LED, 1, (switches_state >> 4) + (switches_state & 0xF));
	}

    return 0;
}


