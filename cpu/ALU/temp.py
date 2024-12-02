for i in range(0, 8):
    print(f"assign A_shifted[{i*4}] = 1'b1;")

print("")

for i in range(0, 8):
    print(f"assign A_shifted[{i*4+1}:{i*4+3}] = A[{i*4+4}:{i*4+6}];")

print("\n-------\n")

for i in range(0, 8):
    print(f"assign A_shifted[{i*4+3}] = 1'b1;")

print("")

for i in range(0, 8):
    print(f"assign A_shifted[{i*4}:{i*4+2}] = A[{i*4+4}:{i*4+6}];")
