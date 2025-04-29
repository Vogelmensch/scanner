import random
import sys

if len(sys.argv) != 2:
    print("Usage: python generate_input.py <number of inputs>")

try:
    n = int(sys.argv[1])
    print(n)

    for _ in range(n):
        height = random.randint(1, 30)
        width = random.randint(1, 30)
        full = height + width - 1
        half = int(full / 2)

        for i in range(height):
            print(random.randint(0, height), end=" " if i < height-1 else "\n")
        for i in range(full):
            print(random.randint(0, i+2) if i <= half else random.randint(0, full-i), end=" " if i < full-1 else "\n")
        for i in range(width):
            print(random.randint(0, width), end=" " if i < width-1 else "\n")
        for i in range(full):
            print(random.randint(0, i+2) if i <= half else random.randint(0, full-i), end=" " if i < full-1 else "\n")

except:
    ValueError("Please provide an integer")

