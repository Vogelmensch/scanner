import random
import sys
import numpy as np

MAX_HEIGHT = 5
MAX_WIDTH = 5

def generate_random_data(n):
    for _ in range(n):
        height = random.randint(1, MAX_HEIGHT)
        width = random.randint(1, MAX_WIDTH)
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

# n: Number of matrices to return
# prob: Probability of an element to be "full"
def generate_random_valid_data(n, prob):
    for _ in range(n):
        height = MAX_HEIGHT
        width = MAX_WIDTH

        random_matrix = np.where(np.random.rand(height, width) < prob, 1, 0)

        sensor_data_horizontal = np.sum(random_matrix, axis=1)
        sensor_data_diagonal_lr = np.array([np.sum(np.diagonal(np.fliplr(random_matrix), offset)) for offset in range(width-1, 1-height-1, -1)])
        sensor_data_vertical = np.sum(random_matrix, axis=0)
        sensor_data_diagonal_rl = np.array([np.sum(np.diagonal(random_matrix, offset)) for offset in range(1-height, width)])

        for idx, n in enumerate(sensor_data_horizontal):
            print(str(n), end=" " if idx < len(sensor_data_horizontal)-1 else "\n")
        for idx, n in enumerate(sensor_data_diagonal_lr):
            print(str(n), end=" " if idx < len(sensor_data_diagonal_lr)-1 else "\n")
        for idx, n in enumerate(sensor_data_vertical):
            print(str(n), end=" " if idx < len(sensor_data_vertical)-1 else "\n")
        for idx, n in enumerate(sensor_data_diagonal_rl):
            print(str(n), end=" " if idx < len(sensor_data_diagonal_rl)-1 else "\n")



if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_input.py <number of inputs> <probability for 1s>")
        sys.exit()


    n = int(sys.argv[1])
    prob = float(sys.argv[2])
    print(n)
    #generate_random_data(n)
    generate_random_valid_data(n, prob)
        
