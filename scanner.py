import numpy as np

class ScannerVariable:
    def __init__(self, value = None, is_fixed=False):
        self.value = value          # 0 -> unassigned. Otherwise: Boolean
        self.is_fixed = is_fixed    # are we 100% certain about this variable?



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
        self.matrix = np.empty((self.height, self.width), dtype=ScannerVariable)
        for row in range(self.height):
            for col in range(self.width):
                self.matrix[row, col] = ScannerVariable()

        # we can be certain about all the rows and columns which are either empty or full
        # horizontals
        for idx, data in enumerate(self.sensor_data_horizontal):
            if data == 0:
                self.matrix[idx, :] = ScannerVariable(False, True)
            elif data == self.width:
                self.matrix[idx, :] = ScannerVariable(True, True)
        # verticals
        for idx, data in enumerate(self.sensor_data_vertical):
            if data == 0:
                self.matrix[:, idx] = ScannerVariable(False, True)
            elif data == self.height:
                self.matrix[:, idx] = ScannerVariable(True, True)
        # lr-diagonal
        for idx, data in enumerate(self.sensor_data_diagonal_lr):
            idx_from_x = 0 if idx < self.height else idx-self.height+1
            idx_from_y = 0 if idx < self.width else idx-self.width+1
            idx_to_x = idx+1 if idx < self.width else self.width
            idx_to_y = idx+1 if idx < self.height else self.height
            if data == 0:
                np.fill_diagonal(np.fliplr(self.matrix[idx_from_y:idx_to_y, idx_from_x:idx_to_x]), ScannerVariable(False, True))
            elif data == self.height + self.width - 1:
                np.fill_diagonal(np.fliplr(self.matrix[idx_from_y:idx_to_y, idx_from_x:idx_to_x]), ScannerVariable(True, True))
        # rl-diagonal
        for idx, data in enumerate(self.sensor_data_diagonal_rl):
            idx_from_x = 0 if idx < self.height else idx-self.height+1
            idx_from_y = self.height-(idx+1) if idx < self.height else 0
            idx_to_x = idx+1 if idx < self.width else self.width
            idx_to_y = self.height if idx < self.width else self.height-(idx-self.width+1)
            if data == 0:
                np.fill_diagonal(self.matrix[idx_from_y:idx_to_y, idx_from_x:idx_to_x], ScannerVariable(False, True))
            elif data == self.height + self.width - 1:
                np.fill_diagonal(self.matrix[idx_from_y:idx_to_y, idx_from_x:idx_to_x], ScannerVariable(True, True))

        # starting-evaluation is probably not good. We gotta start somewhere.
        self.currentEval = np.inf

        self.temp = 1

        self.counter = 0

    # evaluate assignment by comparing it to the actual sensor_data
    # return tuple (<bool> is_valid, <int> error_count)
    # lower is better; 0 is perfect.
    def eval_assignment(self, assignment):
        # get the boolean values
        assignment = np.vectorize(lambda scanner_variable: scanner_variable.value)(assignment)

        # count True elements in rows
        assignment_horizontal = np.count_nonzero(assignment, axis=1)

        # count True elements in left-right-diagonals
        assignment_flipped = np.fliplr(assignment)
        assignment_diagonal_lr = np.array([np.count_nonzero(np.diagonal(assignment_flipped, offset)) for offset in range(self.height-1, -self.width, -1)])

        # count True elements in cols
        assignment_vertical = np.count_nonzero(assignment, axis=0)

        # count True elements in right-left-diagonals
        assignment_diagonal_rl = np.array([np.count_nonzero(np.diagonal(assignment, offset)) for offset in range(-(self.width-1), self.height)])
        
        # Check whether the assignment is valid
        is_valid = not any([np.any(self.sensor_data_horizontal < assignment_horizontal), 
                                np.any(self.sensor_data_vertical < assignment_vertical),
                                np.any(self.sensor_data_diagonal_lr < assignment_diagonal_lr),
                                np.any(self.sensor_data_diagonal_rl < assignment_diagonal_rl)])
        
        print(self.sensor_data_diagonal_lr)
        print(assignment_diagonal_lr)
        print(self.sensor_data_diagonal_lr < assignment_diagonal_lr)

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

        # check termination conditions
        if not is_valid or idx > self.height * self.width:
            return False 
        if error_count == 0:
            # assign the correct solution to the global matrix
            self.matrix = matrix
            return True
        
        # switch value of current element
        x = idx % self.width
        y = idx / self.width
        element = matrix[x, y]
        matrix_left = matrix.copy()
        matrix_right = matrix.copy()
        if not element.is_fixed:
            matrix_left[x,y].value = False
            matrix_right[x,y].value = True
       
        return self.backtracking_search_helper(matrix_left, idx+1) or self.backtracking_search_helper(matrix_right, idx+1)

    # wrapper
    def backtracking_search(self):
        return self.backtracking_search_helper(self.matrix, 0)


    def __str__(self):
        str = ""
        for row in np.vectorize(lambda b: ' ' if b.value == None else '#' if b.value else '.')(self.matrix):
            for char in row:
                print(char, end="")
            print()
        return str






    # --- LOCAL SEARCH STUFF BELOW ---



    # change every cell and evaluate the new state
    # return the evaluations in a matrix
    # TODO: can be done more efficiently, I'm sure
    def assignAndEvaluate(self):
        height, width = self.matrix.shape
        evaluations = np.zeros((height, width))

        for i in range(height):
            for j in range(width):
                # change assignment of (i,j)
                assignment = self.matrix.copy()
                assignment[i,j] = not assignment[i,j]
                evaluations[i,j] = self.evalAssignment(assignment)
        
        return evaluations

    # change the element in self.matrix, whose correspondend element in the evaluation is the lowest
    # only do this if this element is lower than the current eval. 
    # return whether the change was successful
    def change_matrix_from_evaluation(self, eval):
        indexOfLowest = np.unravel_index(np.argmin(eval, axis=None), eval.shape)
        lowest = eval[indexOfLowest]

        if lowest < self.currentEval:
            self.matrix[indexOfLowest] = not self.matrix[indexOfLowest]
            self.currentEval = lowest
            return True
        else:
            return False

    # do hillclimb until a local minimum is reached
    def hillClimb(self):
        eval = self.assignAndEvaluate()
        while(self.changeMatrixFromEvaluation(eval)):
            eval = self.assignAndEvaluate()

    def annealingStep(self, probabilityConstant):
        # 1. choose random neighbor of matrix (change one random element)
        neighbor = self.matrix.copy()
        randomIndex = (np.random.randint(self.height), np.random.randint(self.width))
        neighbor[randomIndex] = not neighbor[randomIndex]

        # 2. If neighbor is not worse, then go there!
        eval = self.evalAssignment(neighbor)
        if eval <= self.currentEval:
            self.matrix = neighbor
            self.currentEval = eval
        # If neighbor is worse, go there with decreasing probability
        else:
            #temp = self.temp(190, self.tempCounter)
            # probability = np.exp(- (eval - self.currentEval) / self.temp(10, self.tempCounter))
            probability = np.exp((self.currentEval - eval) / self.temp)

            # if self.counter % 1000 == 0: 
            #     print(probability)
            if np.random.rand() < probability:
                self.matrix = neighbor
                self.currentEval = eval

        # decrease temperature geometrically
        self.temp = 0.999999 * self.temp

        # print the matrix every 10.000 steps
        if self.counter % 1000 == 0:
            print(self)
        
        self.counter += 1

        #print(self.temp)
        

    def simulatedAnnealing(self, probabilityConstant, stopAfter = np.inf, activatePrint=False):
        while self.currentEval > 0 and self.counter < stopAfter:
            if activatePrint:
                print(self.currentEval)

            self.annealingStep(probabilityConstant)





def hillClimbRandomRestart(sensor_data):    
    eval = 1
    while eval > 0:
        scanner = Scanner(sensor_data)
        scanner.hillClimb()
        eval = scanner.currentEval
        print(eval)
    print(scanner)


sensor_data = [[10,10,6,4,6,8,13,15,11,6],[0,1,2,2,2,2,4,5,5,6,7,6,5,6,6,5,5,6,6,3,2,2,1,0],[2,4,5,5,7,6,7,10,10,10,7,3,3,5,5],[0,0,1,3,4,4,4,4,3,4,5,7,8,8,9,9,6,4,4,2,0,0,0,0]]
# sensor_data = [[2,1,0],[1,0,2,0,0],[1,1,1],[0,0,2,0,1]]

scanner = Scanner(sensor_data)
print(scanner)
print(scanner.backtracking_search())
print(scanner)









# hillClimbRandomRestart(sensor_data)


# results = {}
# for i in range(1, 25):
#     scanner = Scanner(sensor_data)
#     scanner.simulatedAnnealing(probabilityConstant = i*30, stopAfter=10**6, activatePrint=False)
#     print(str(i*30) + " finished with " + str(scanner.currentEval))
#     results[i] = scanner.currentEval
# print(max(results))
# print(results[max(results)])

# scanner = Scanner(sensor_data)
# print(scanner)
# scanner.simulatedAnnealing(probabilityConstant=2000)
# print(scanner)