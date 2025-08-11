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
        height = 10
        width = 15

        random_matrix = np.where(np.random.rand(height, width) < prob, 1, 0)
        
        matrix_to_data(random_matrix, height, width)


def generate_chunk(n_matrices, chance, height, width):
    for _ in range(n_matrices):
        chunk_matrix = np.zeros((height, width), dtype=int)
        
        # make one random element 1
        # chunk_matrix[np.random.randint(0, height), np.random.randint(0, width)] = 1
        chunk_matrix[int(height/2), int(width/2)] = 1
        
        # maybe assign 1 at cells around cells that are already 1, iteratively
        for _ in range(min(height, width)):
            
            for h in range(height):
                for w in range(width):
                    # up
                    if h > 0:
                        chunk_matrix[h, w] = 1 if chunk_matrix[h-1, w] == 1 and np.random.rand() < chance else chunk_matrix[h, w]
                    # right
                    if w < width-1:
                        chunk_matrix[h, w] = 1 if chunk_matrix[h, w+1] == 1 and np.random.rand() < chance else chunk_matrix[h, w]
                    # down
                    if h < height-1:
                        chunk_matrix[h, w] = 1 if chunk_matrix[h+1, w] == 1 and np.random.rand() < chance else chunk_matrix[h, w]
                    # left
                    if w > 0:
                        chunk_matrix[h, w] = 1 if chunk_matrix[h, w-1] == 1 and np.random.rand() < chance else chunk_matrix[h, w]
            
        matrix_to_data(chunk_matrix, height, width)
   

# gets matrix of ones and zeros
def matrix_to_data(matrix, height, width):
    sensor_data_horizontal = np.sum(matrix, axis=1)
    sensor_data_diagonal_lr = np.array([np.sum(np.diagonal(np.fliplr(matrix), offset)) for offset in range(width-1, 1-height-1, -1)])
    sensor_data_vertical = np.sum(matrix, axis=0)
    sensor_data_diagonal_rl = np.array([np.sum(np.diagonal(matrix, offset)) for offset in range(1-height, width)])

    for idx, n in enumerate(sensor_data_horizontal):
        print(str(n), end=" " if idx < len(sensor_data_horizontal)-1 else "\n")
    for idx, n in enumerate(sensor_data_diagonal_lr):
        print(str(n), end=" " if idx < len(sensor_data_diagonal_lr)-1 else "\n")
    for idx, n in enumerate(sensor_data_vertical):
        print(str(n), end=" " if idx < len(sensor_data_vertical)-1 else "\n")
    for idx, n in enumerate(sensor_data_diagonal_rl):
        print(str(n), end=" " if idx < len(sensor_data_diagonal_rl)-1 else "\n")



if __name__ == "__main__":
    # if len(sys.argv) != 3:
    #     print("Usage: python generate_input.py <number of inputs> <probability for 1s>")
    #     sys.exit()


    n = int(sys.argv[1])
    prob = float(sys.argv[2])
    # print(n)
    # #generate_random_data(n)
    # generate_random_valid_data(n, prob)
    print(n)
    #generate_random_valid_data(n=10000, prob=0.4)
    generate_chunk(n_matrices=n, chance=prob, height=10, width=15)