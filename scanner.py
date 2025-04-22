import numpy as np

class Scanner:
    # initiates a scanner with a random matrix
    def __init__(self, height, width, sensorData):
        self.height = height
        self.width = width

        # sensorData is an array of arrays, representing the input numbers
        sensorData = sensorData
         # Load sensor data
        self.sensorDataHorizontal = np.array(sensorData[0])
        self.sensorDataDiagonalLR = np.array(sensorData[1])
        self.sensorDataVertical = np.array(sensorData[2])
        self.sensorDataDiagonalRL = np.array(sensorData[3]) 

        # represents the (solution) matrix. Start with a random assignment.
        self.matrix = np.random.choice([True, False], size=(height, width))

        # starting evaluation is probably not good. We gotta start somewhere.
        self.currentEval = np.inf

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

    # print matrix
    def printMatrix(self):
        print(self.matrix)




sensorData = [[2,1,0],[1,0,2,0,0],[1,1,1],[0,0,2,0,1]]

for _ in range(1):
    height = len(sensorData[0])
    width = len(sensorData[2])
    scanner = Scanner(height, width, sensorData)
    scanner.printMatrix()
    scanner.hillClimb()
    scanner.printMatrix()