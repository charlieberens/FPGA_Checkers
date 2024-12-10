import argparse


def unsigned_32_bit_to_binary_string(n):
    return format(n, "032b")


def convert_to_board(n):
    # bin_string = unsigned_32_bit_to_binary_string(n)
    bin_string = n
    # Reverse the string so that the least significant bit is at the start
    bin_string = bin_string[::-1]
    out = []
    for i in range(0, 32, 4):
        row = bin_string[i : i + 4]
        if i % 8 == 0:
            out.append(f"{" - ".join(row)} -")
        else:
            out.append(f"- {" - ".join(row)}")
    return "\n".join(out)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=str)
    args = parser.parse_args()

    print(convert_to_board(args.input))


main()
