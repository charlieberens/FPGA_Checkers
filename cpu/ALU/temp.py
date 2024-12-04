# for i in range(0, 8):
#     print(f"assign A_shifted[{i*4}] = 1'b1;")

for i in range(0, 8):
    if i % 2 == 0:
        print(f"assign A_shifted[{i*4+3}:{i*4}] = A[{i*4+7}:{i*4+4}];")
    else:
        print(f"assign A_shifted[{i*4+3}:{i*4+1}] = A[{i*4+6}:{i*4+4}];")

print("")

for i in range(0, 8):
    if i % 2 == 0:
        print(f"assign A_shifted[{i*4+2}:{i*4}] = A[{i*4+7}:{i*4+5}];")
    else:
        print(f"assign A_shifted[{i*4+3}:{i*4}] = A[{i*4+7}:{i*4+4}];")
