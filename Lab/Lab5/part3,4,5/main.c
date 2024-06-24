/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xil_printf.h"
#include "xbram.h"
#include <stdio.h>
#include "pl_ram_ctrl.h"
#include "xscugic.h"
#include "xgpio.h"
#include "ff.h"
#include "xstatus.h"
#include "xil_cache.h"


#include "stdio.h"
#include "string.h"
#include "xparameters.h"	/* SDK generated parameters */
#include "xsdps.h"		/* SD device driver */
#include "xplatform_info.h"

#define BRAM_CTRL_BASE      XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define BRAM_CTRL_HIGH      XPAR_AXI_BRAM_CTRL_0_S_AXI_HIGHADDR
#define PL_RAM_BASE         XPAR_PL_RAM_CTRL_0_S00_AXI_BASEADDR
#define PL_RAM_START        PL_RAM_CTRL_S00_AXI_SLV_REG0_OFFSET
#define PL_RAM_INIT_DATA    PL_RAM_CTRL_S00_AXI_SLV_REG1_OFFSET
#define PL_RAM_LEN          PL_RAM_CTRL_S00_AXI_SLV_REG2_OFFSET
#define PL_RAM_ST_ADDR      PL_RAM_CTRL_S00_AXI_SLV_REG3_OFFSET

#define GPIO_DEVICE_ID      XPAR_AXI_GPIO_0_DEVICE_ID
#define INTC_DEVICE_ID	    XPAR_SCUGIC_SINGLE_DEVICE_ID
#define GPIO_INTR_ID        XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
#define GPIO_INTR_MASK      XGPIO_IR_CH1_MASK
#define GPIO_BASE_ADDR      XPAR_AXI_GPIO_0_BASEADDR

#define TEST_START_VAL      0xC
/*
 * BRAM bytes number
 */
#define BRAM_BYTENUM        4

XGpio PL_Gpio ;
XScuGic INTCInst;

int Len  ;
int Start_Addr ;
int Gpio_flag ;
int freq;
/*
 * Function declaration
 */
int bram_read_write() ;
int IntrInitFuntion(u16 DeviceId, XGpio *GpioInstancePtr);
void GpioHandler(void *InstancePtr);
/////////new for sd card
static FATFS fatfs;

static int SD_Init()
{
	FRESULT rc;
	TCHAR *Path = "0:/";
	rc = f_mount(&fatfs,Path,0);
	if (rc) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
static int SD_Eject()
{
	FRESULT rc;
	TCHAR *Path = "0:/";
	rc = f_mount(&fatfs,Path,1);
	if (rc) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

static int ReadFile(char *FileName,u32 DestinationAddress,u32 ByteLength)
{
    FIL fil;
    FRESULT rc;
    UINT br;
    rc = f_open(&fil,FileName,FA_READ);
    if(rc)
    {
        xil_printf("ERROR : f_open returned %d\r\n",rc);
        return XST_FAILURE;
    }
    rc = f_lseek(&fil, 0);
    if(rc)
    {
        xil_printf("ERROR : f_lseek returned %d\r\n",rc);
        return XST_FAILURE;
    }
    rc = f_read(&fil, (void*)DestinationAddress,ByteLength,&br);
    if(rc)
    {
        xil_printf("ERROR : f_read returned %d\r\n",rc);
        return XST_FAILURE;
    }
    rc = f_close(&fil);
    if(rc)
    {
        xil_printf(" ERROR : f_close returned %d\r\n", rc);
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

static int WriteFile(char *FileName,u32 SourceAddress,u32 ByteLength)
{
    FIL fil;
    FRESULT rc;
    UINT bw;

    rc = f_open(&fil,FileName,FA_WRITE);
    if(rc)
    {
        xil_printf("ERROR : f_open returned %d\r\n",rc);
        return XST_FAILURE;
    }
    rc = f_lseek(&fil, 0);
    if(rc)
    {
        xil_printf("ERROR : f_lseek returned %d\r\n",rc);
        return XST_FAILURE;
    }
    rc = f_write(&fil,(void*) SourceAddress,ByteLength,&bw);
    if(rc)
    {
        xil_printf("ERROR : f_write returned %d\r\n", rc);
        return XST_FAILURE;
    }
    rc = f_close(&fil);
    if(rc){
        xil_printf("ERROR : f_close returned %d\r\n",rc);
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

static int data_prepare(char data[16]){
	int power = 1;
	int out = 0;
	for (int i = 15; i>=0 ; i--){
		if(data[i] == '1'){
			out += power;
			power *= 2;
		}else if(data[i] == '0'){
			power *= 2;
		}
	}
	return out;
}
static void decimal2bin(int input,char output[16]){
        int tmp = input;
	for(int i = 15;i >= 0; i--){
		if(tmp%2 == 1){
			output[i] = '1';
		}
		else if (tmp%2 == 0){
			output[i] = '0';
		}
		tmp /= 2;
	}
}
char SDtmp_str[1024 * 16];

int main()
{
	//reading from SD card
    int Status;
        Status = SD_Init(&fatfs);
        if (Status != XST_SUCCESS)
        {
      	 print("file system init failed\n");
        	 return XST_FAILURE;
        }
        print("SD Card is initialized successfully \r\n");
        print("Start reading sinSignal.mem from SD card\r\n");
        Status = ReadFile("sin.txt",(u32) SDtmp_str, 1024 * 16);
            if (Status != XST_SUCCESS)
            {
            	print("file read failed\r\n");
            	return XST_FAILURE;
            }

     print("data loaded\r\n");
    //sending data to PL
	Gpio_flag = 1 ;

	Status = XGpio_Initialize(&PL_Gpio, GPIO_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	Status = IntrInitFuntion(GPIO_DEVICE_ID, &PL_Gpio) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	Start_Addr = 0;
	Len = 256;
	while(1)
	{
		if (Gpio_flag)
		{
			Gpio_flag = 0 ;
			printf("Please provide coefficient of output signal\t\n") ;
			scanf("%d", &freq) ;
//			freq = 2;
			Status = bram_read_write() ;
			if (Status != XST_SUCCESS)
			{
				xil_printf("Bram Test Failed!\r\n") ;
				xil_printf("******************************************\r\n");
				Gpio_flag = 1 ;
			}
		}
	}
}


int bram_read_write()
{

	u32 Write_Data;
	int i ;

	/*
	 * if exceed BRAM address range, assert error
	 */
	if ((Start_Addr + Len) > (BRAM_CTRL_HIGH - BRAM_CTRL_BASE + 1)/4)
	{
		xil_printf("******************************************\r\n");
		xil_printf("Error! Exceed Bram Control Address Range!\r\n");
		return XST_FAILURE ;
	}
	/*
	 * Write data to BRAM
	 */
	int index = 0;
	char num[] = "00000000000000000000000000000000";
	for(i = BRAM_BYTENUM*Start_Addr ; i < BRAM_BYTENUM*(Start_Addr + Len) ; i += BRAM_BYTENUM)
	{
		for(int j = 0;j < 16; j++){
			num[j] = SDtmp_str[index];
			index++;
		}
		Write_Data = data_prepare(num);
		xil_printf("data sent is :\n%s \t\n",num) ;
		XBram_WriteReg(XPAR_BRAM_0_BASEADDR, i , Write_Data) ;
	}
	//Set ram read and write length
	PL_RAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_LEN , BRAM_BYTENUM*Len) ;
	//Set ram start address
	PL_RAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_ST_ADDR , BRAM_BYTENUM*Start_Addr) ;
	//Set pl initial data
	PL_RAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_INIT_DATA , freq) ;
	//Set ram start signal
	PL_RAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_START , 1) ;

	return XST_SUCCESS ;
}



int IntrInitFuntion(u16 DeviceId, XGpio *GpioInstancePtr)
{
	XScuGic_Config *IntcConfig;
	int Status ;


	//check device id
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	//intialization
	Status = XScuGic_CfgInitialize(&INTCInst, IntcConfig, IntcConfig->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;


	XScuGic_SetPriorityTriggerType(&INTCInst, GPIO_INTR_ID,
			0xA0, 0x3);

	Status = XScuGic_Connect(&INTCInst, GPIO_INTR_ID,
			(Xil_ExceptionHandler)GpioHandler,
			(void *)GpioInstancePtr) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	XScuGic_Enable(&INTCInst, GPIO_INTR_ID) ;
	//enable interrupt
	XGpio_InterruptEnable(GpioInstancePtr, GPIO_INTR_MASK) ;
	XGpio_InterruptGlobalEnable(GpioInstancePtr) ;


	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			&INTCInst);
	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}

void GpioHandler(void *CallbackRef)
{
		FIL fil;
	    FRESULT rc;
	    UINT bw;
	    char * FileName = "out.txt";
	    rc = f_open(&fil,FileName,FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
	    if(rc)
	    {
	        xil_printf("ERROR : f_open returned %d\r\n",rc);
	    }
	    rc = f_lseek(&fil, 0);
	    if(rc)
	    {
	        xil_printf("ERROR : f_lseek returned %d\r\n",rc);
	    }
	    if(!rc)
	    	xil_printf("file out.txt opened successfully");
	XGpio *GpioInstancePtr = (XGpio *)CallbackRef ;
	int Read_Data ;

	int i ;
	printf("Enter interrupt\t\n");
	//clear interrupt status
	XGpio_InterruptClear(GpioInstancePtr, GPIO_INTR_MASK) ;
	//writing file on sd card


	////////
	char tmp[] = "00000000000000000000000000000000\n";
	char str[32];
	int Status;
	for(i = BRAM_BYTENUM*Start_Addr ; i < BRAM_BYTENUM*(Start_Addr + Len) ; i += BRAM_BYTENUM)
	{
		Read_Data = XBram_ReadReg(XPAR_BRAM_0_BASEADDR , i) ;
		decimal2bin(Read_Data,tmp);
//		sprintf(str,"%X\n",Read_Data);
		f_write(&fil,(const void*)tmp,strlen(tmp),&bw);
		xil_printf("Address is %d\t Read data is %s\t\n",  i/BRAM_BYTENUM ,tmp) ;
	}

	print("successfully wrote in the SDfile.txt. \r\n\r\n");
	//
	Gpio_flag = 1 ;

    rc = f_close(&fil);
    if(rc){
        xil_printf("ERROR : f_close returned %d\r\n",rc);
    }
}
