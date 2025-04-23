import numpy as np

class Scanner:
    # initiates a scanner with a random matrix
    def __init__(self, sensorData):
        self.height = len(sensorData[0])
        self.width = len(sensorData[2])

        # sensorData is an array of arrays, representing the input numbers
        sensorData = sensorData
         # Load sensor data
        self.sensorDataHorizontal = np.array(sensorData[0])
        self.sensorDataDiagonalLR = np.array(sensorData[1])
        self.sensorDataVertical = np.array(sensorData[2])
        self.sensorDataDiagonalRL = np.array(sensorData[3]) 

        # represents the (solution) matrix. Start with a random assignment.
        self.matrix = np.random.choice([True, False], size=(self.height, self.width))

        # starting-evaluation is probably not good. We gotta start somewhere.
        self.currentEval = np.inf

        self.temp = 1

        self.counter = 0

    # evaluate assignment by comparing it to the actual sensorData
    # lower is better; 0 is perfect.
    def evalAssignment(self, assignment):
        # count True elements in rows
        assignmentHorizontal = np.count_nonzero(assignment, axis=1)

        # count True elements in left-right-diagonals
        assignmentFlipped = np.fliplr(assignment)
        assignmentDiagonalLR = [np.count_nonzero(np.diagonal(assignmentFlipped, offset)) for offset in range(self.height-1, -self.width, -1)]

        # count True elements in cols
        assignmentVertical = np.count_nonzero(assignment, axis=0)

        # count True elements in right-left-diagonals
        assignmentDiagonalRL = [np.count_nonzero(np.diagonal(assignment, offset)) for offset in range(-(self.width-1), self.height)]

        # differences between sensor data and current assignment
        diffsHorizontal = np.sum(np.abs(assignmentHorizontal - self.sensorDataHorizontal))
        diffsVertical = np.sum(np.abs(assignmentVertical - self.sensorDataVertical))
        diffsDiagonalLR = np.sum(np.abs(assignmentDiagonalLR - self.sensorDataDiagonalLR))
        diffsDiagonalRL = np.sum(np.abs(assignmentDiagonalRL - self.sensorDataDiagonalRL))

        return diffsHorizontal + diffsVertical + diffsDiagonalLR + diffsDiagonalRL

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
    def changeMatrixFromEvaluation(self, eval):
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

    def __str__(self):
        str = ""
        for row in np.vectorize(lambda b: '#' if b else '.')(self.matrix):
            for char in row:
                print(char, end="")
            print()
        return str



def hillClimbRandomRestart(sensorData):    
    eval = 1
    while eval > 0:
        scanner = Scanner(sensorData)
        scanner.hillClimb()
        eval = scanner.currentEval
        print(eval)
    print(scanner)


sensorData = [[10,10,6,4,6,8,13,15,11,6],[0,1,2,2,2,2,4,5,5,6,7,6,5,6,6,5,5,6,6,3,2,2,1,0],[2,4,5,5,7,6,7,10,10,10,7,3,3,5,5],[0,0,1,3,4,4,4,4,3,4,5,7,8,8,9,9,6,4,4,2,0,0,0,0]]
# sensorData = [[2,1,0],[1,0,2,0,0],[1,1,1],[0,0,2,0,1]]
# hillClimbRandomRestart(sensorData)


# results = {}
# for i in range(1, 25):
#     scanner = Scanner(sensorData)
#     scanner.simulatedAnnealing(probabilityConstant = i*30, stopAfter=10**6, activatePrint=False)
#     print(str(i*30) + " finished with " + str(scanner.currentEval))
#     results[i] = scanner.currentEval
# print(max(results))
# print(results[max(results)])

scanner = Scanner(sensorData)
print(scanner)
scanner.simulatedAnnealing(probabilityConstant=2000)
print(scanner)