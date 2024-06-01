import random

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

def main():
    baud_rate = 115200

    test_vector = [random.randint(0, 255) for _ in range(2048)]

    with open("test_vector.txt", "w") as file:
        for data in test_vector:
            binary_str = bin(data)[2:].zfill(8)
            file.write(binary_str + "\n")

    python_outputs = []
    uart_frames = []
    for data in test_vector:
        uart_frame, bit_interval = generate_uart_frame(data, baud_rate)
        uart_frames.append(uart_frame)
        received_data = uart_receive(uart_frame, baud_rate)
        python_outputs.append(received_data)

    with open("python_outputs.txt", "w") as file:
        for data in python_outputs:
            binary_str = bin(data)[2:].zfill(8)
            file.write(binary_str + "\n")

    with open("python_uart_frames.txt", "w") as file:
        for frame in uart_frames:
            frame_str = ''.join(str(bit) for bit in frame)
            file.write(frame_str + "\n")

if __name__ == "__main__":
    main()
