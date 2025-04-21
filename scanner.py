import numpy as np

class Scanner:
    # initiates a scanner with a random matrix
    def __init__(self, height, width, sensorData):
        self.height = height
        self.width = width
        # sensorData is an array of arrays, representing the input numbers
        self.sensorData = sensorData 

        # represents the (solution) matrix. Start with a random assignment.
        self.matrix = np.random.choice([True, False], size=(height, width))

        # starting evaluation is probably not good. We gotta start somewhere.
        self.currentEval = np.inf

    # evaluate assignment by comparing it to the actual sensorData
    # lower is better; 0 is perfect.
    # TODO: currently only evals horizontals and verticals
    def evalAssignment(self, assignment):
        # count True elements in rows
        assignmentHorizontal = [np.count_nonzero(assignment[i,:]) for i in range(self.width)]
        # count True elements in cols
        assignmentVertical = [np.count_nonzero(assignment[:,i]) for i in range(self.height)]
        # count True elements in left-right-diagonals
        # TODO
        # count True elements in right-left-diagonals
        diagRange = np.ceil(self.height/2)
        diagsRL = [np.diagonal(assignment, offset) for offset in range(self.height-1, )] # <-------- TODO 
        assignmentDiagonalRL = [np.count_nonzero(diag) for diag in diagsRL]

        # TODO: indices may differ when adding diagonals
        sensorDataHorizontal = self.sensorData[0]
        sensorDataVertical = self.sensorData[1]
        sensorDataDiagonalLR = self.sensorData[2]
        sensorDataDiagonalRL = self.sensorData[3]

        diffsHorizontal = np.sum(np.abs(assignmentHorizontal - sensorDataHorizontal))
        diffsVertical = np.sum(np.abs(assignmentVertical - sensorDataVertical))

        return diffsHorizontal + diffsVertical

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

    
sensorData = np.array([[2,1,0],[1,1,1]])

for _ in range(2):
    scanner = Scanner(3,3, sensorData)
    scanner.printMatrix()
    scanner.hillClimb()
    scanner.printMatrix()