import matplotlib.pyplot as plt
import numpy as np

verilog_outputs = []
with open("verilog_outputs.txt", "r") as file:
    for line in file:
        verilog_outputs.append(int(line.strip(), 2)) 

python_outputs = []
with open("python_outputs.txt", "r") as file:
    for line in file:
        python_outputs.append(int(line.strip(), 2))

test_vectors = []
with open("test_vector.txt", "r") as file:
    for line in file:
        test_vectors.append(int(line.strip(), 2))

difference_p_v = np.array(verilog_outputs) - np.array(python_outputs)

difference_t_p = np.array(test_vectors) - np.array(python_outputs)

difference_t_v = np.array(test_vectors) - np.array(verilog_outputs)

plt.figure(figsize=(10, 6))
plt.plot(difference_p_v, label='Difference (Verilog - Python)', color='green')
plt.title('Difference Between Verilog and Python Outputs')
plt.xlabel('Index')
plt.ylabel('Difference')
plt.legend()
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(difference_t_p, label='Difference (Test Vector - Python)', color='red')
plt.title('Difference Between Test Vector and Python Outputs')
plt.xlabel('Index')
plt.ylabel('Difference')
plt.legend()
plt.grid(True)
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(difference_t_v, label='Difference (Test Vector - Verilog)', color='c')
plt.title('Difference Between Test Vector and Verilog Outputs')
plt.xlabel('Index')
plt.ylabel('Difference')
plt.legend()
plt.grid(True)
plt.show()
