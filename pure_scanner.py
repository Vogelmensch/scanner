import numpy as np

class Scanner:
    # initiates a scanner with a random matrix
    def __init__(self, sensor_data):
        self.height = len(sensor_data[0])
        self.width = len(sensor_data[2])

        # sensor_data is an array of arrays, representing the input numbers
        sensor_data = sensor_data
         # Load sensor data
        self.sensor_data_horizontal = np.array(sensor_data[0])
        self.sensor_data_diagonal_lr = np.array(sensor_data[1])
        self.sensor_data_vertical = np.array(sensor_data[2])
        self.sensor_data_diagonal_rl = np.array(sensor_data[3]) 

        # represents the (solution) matrix.
        self.matrix = np.zeros((self.height, self.width))

        # starting-evaluation is probably not good. We gotta start somewhere.
        self.currentEval = np.inf

        self.temp = 1

        self.counter = 0

    # evaluate assignment by comparing it to the actual sensor_data
    # return tuple (<bool> is_valid, <int> error_count)
    # lower is better; 0 is perfect.
    def eval_assignment(self, assignment):
        # count True elements in rows
        assignment_horizontal = np.count_nonzero(assignment, axis=1)

        # count True elements in left-right-diagonals
        assignment_flipped = np.fliplr(assignment)
        assignment_diagonal_lr = np.array([np.count_nonzero(np.diagonal(assignment_flipped, offset)) for offset in range(self.width-1, 1-self.height-1, -1)])

        # count True elements in cols
        assignment_vertical = np.count_nonzero(assignment, axis=0)

        # count True elements in right-left-diagonals
        # Erkenntnis:
        # Es kann mehr als zwei mal "rum gehen". Wie kommt man an alle Diagonalen ran?
        assignment_diagonal_rl = np.array([np.count_nonzero(np.diagonal(assignment, offset)) for offset in range(1-self.height, self.width)])

        # Check whether the assignment is valid
        is_valid = not any([np.any(self.sensor_data_horizontal < assignment_horizontal), 
                                np.any(self.sensor_data_vertical < assignment_vertical),
                                np.any(self.sensor_data_diagonal_lr < assignment_diagonal_lr),
                                np.any(self.sensor_data_diagonal_rl < assignment_diagonal_rl)])

        # differences between sensor data and current assignment
        diffs_horizontal = np.sum(np.abs(assignment_horizontal - self.sensor_data_horizontal))
        diffs_vertical = np.sum(np.abs(assignment_vertical - self.sensor_data_vertical))
        diffs_diagonal_lr = np.sum(np.abs(assignment_diagonal_lr - self.sensor_data_diagonal_lr))
        diffs_diagonal_rl = np.sum(np.abs(assignment_diagonal_rl - self.sensor_data_diagonal_rl))

        error_count = diffs_horizontal + diffs_vertical + diffs_diagonal_lr + diffs_diagonal_rl

        return is_valid, error_count
        

    # recursive function
    # returns False if matrix is impossible and True if it is the correct assignment
    # idx is an integer 
    def backtracking_search_helper(self, matrix, idx):
        # evaluate matrix
        is_valid, error_count = self.eval_assignment(matrix)

        print(matrix)

        if error_count == 0:
            # assign the correct solution to the global matrix
            self.matrix = matrix
            return True
        
        # check termination conditions
        if not is_valid or idx >= self.height * self.width:
            return False 

        
        # set value of current element
        matrix_flattened = matrix.reshape(-1)

        # else, assign all possible values
        matrix_left = np.array(matrix_flattened)
        matrix_right = np.array(matrix_flattened)
        matrix_left[idx] = False
        matrix_right[idx] = True
       
        # recursive call; reshape left and right matrices to be of the original dimension again
        return self.backtracking_search_helper(matrix_left.reshape((self.height, self.width)), idx+1) or self.backtracking_search_helper(matrix_right.reshape((self.height, self.width)), idx+1)

    # wrapper
    def backtracking_search(self):
        matrix_right = np.array(self.matrix)
        matrix_left = np.array(self.matrix)
        matrix_left[0,0] = False
        matrix_right[0,0] = True
        return self.backtracking_search_helper(matrix_left, 1) or self.backtracking_search_helper(matrix_right, 1)


    def __str__(self):
        str = ""
        for row in np.vectorize(lambda b: ' ' if b == None else '#' if b else '.')(self.matrix):
            for char in row:
                print(char, end="")
            print()
        return str



sensor_data = [[10,10,6,4,6,8,13,15,11,6],[0,1,2,2,2,2,4,5,5,6,7,6,5,6,6,5,5,6,6,3,2,2,1,0],[2,4,5,5,7,6,7,10,10,10,7,3,3,5,5],[0,0,1,3,4,4,4,4,3,4,5,7,8,8,9,9,6,4,4,2,0,0,0,0]]
# sensor_data = [[3,2,2,2,1], [0,0,2,2,3,1,2,0,0], [0,2,4,3,1], [0,0,1,2,3,0,2,1,1]]
#sensor_data = [[1],[1],[1],[1]]
# sensor_data = [[2,1,0],[1,0,2,0,0],[1,1,1],[0,0,2,0,1]]

scanner = Scanner(sensor_data)
print(scanner)
print(scanner.backtracking_search())
print(scanner)







