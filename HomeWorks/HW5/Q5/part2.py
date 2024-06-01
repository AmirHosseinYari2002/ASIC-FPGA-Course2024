import time
import matplotlib.pyplot as plt

def uart_transmit(data, baud_rate):
    bit_interval = 1.0 / baud_rate

    start_bit = 0
    data_bits = [(data >> i) & 1 for i in range(8)]
    stop_bit = 1

    uart_frame = [start_bit] + data_bits + [stop_bit]

    print("UART Frame:", uart_frame)
    
    for bit in uart_frame:
        print("Transmitting bit:", bit)
        time.sleep(bit_interval)

    return uart_frame, bit_interval

def plot_uart_frame(uart_frame, bit_interval):
    time_values = [i * bit_interval for i in range(len(uart_frame) * 2)]
    signal_values = []

    for bit in uart_frame:
        signal_values.extend([bit, bit])
    
    time_values.append(time_values[-1] + bit_interval)
    signal_values.append(uart_frame[-1])
    
    plt.figure(figsize=(10, 4))
    plt.step(time_values, signal_values, where='post')
    plt.title('UART Frame')
    plt.xlabel('Time (s)')
    plt.ylabel('Signal')
    plt.ylim(-0.5, 1.5)
    plt.yticks([0, 1], ['LOW', 'HIGH'])
    plt.grid(True)
    plt.show()

def main():
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

            uart_frame, bit_interval = uart_transmit(data, baud_rate)
            plot_uart_frame(uart_frame, bit_interval)
        
        except ValueError:
            print("Invalid input. Please enter a number between 0 and 255.")

if __name__ == "__main__":
    main()
