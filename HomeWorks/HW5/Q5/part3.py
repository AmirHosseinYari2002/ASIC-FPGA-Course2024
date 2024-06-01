import matplotlib.pyplot as plt
import numpy as np

def uart_receive(uart_frame, baud_rate):
    bit_interval = 1.0 / baud_rate
    
    start_bit = uart_frame[0]
    if start_bit != 0:
        raise ValueError("Invalid start bit")

    data_bits = uart_frame[1:9]
    data_byte = 0
    for i, bit in enumerate(data_bits):
        data_byte |= (bit << i)

    stop_bit = uart_frame[9]
    if stop_bit != 1:
        raise ValueError("Invalid stop bit")

    return data_byte

def generate_uart_frame(data, baud_rate):
    bit_interval = 1.0 / baud_rate


    start_bit = 0
    data_bits = [(data >> i) & 1 for i in range(8)]
    stop_bit = 1

    uart_frame = [start_bit] + data_bits + [stop_bit]

    return uart_frame, bit_interval

if __name__ == "__main__":
    baud_rate = 115200

    while True:
        try:
            input_data = input("Enter a byte to send (0-255), or 'exit' to quit: ")
            if input_data.lower() == 'exit':
                break

            data = int(input_data)
            if data < 0 or data > 255:
                print("Please enter a valid byte (0-255).")
                continue

            uart_frame, bit_interval = generate_uart_frame(data, baud_rate)
            
            print("Generated UART Frame:", uart_frame)

            received_data = uart_receive(uart_frame, baud_rate)
            print("Received Data Byte:", received_data)
        
        except ValueError:
            print("Invalid input. Please enter a number between 0 and 255.")
