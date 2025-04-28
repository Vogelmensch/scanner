import numpy as np
from enum import Enum

class Assignment(Enum):
    UNASSIGNED = 1
    EMPTY = 2
    FULL = 3

class ScannerObject:
    def __init__(self, x, y):
        self.assignment = Assignment.UNASSIGNED
        self.x = x
        self.y = y


class Scanner:
    # initiates a scanner
    def __init__(self, sensor_data):
        self.height = len(sensor_data[0])
        self.width = len(sensor_data[2])

        # Load sensor data
        self.sensor_data_horizontal = np.array(sensor_data[0])
        self.sensor_data_diagonal_lr = np.array(sensor_data[1])
        self.sensor_data_vertical = np.array(sensor_data[2])
        self.sensor_data_diagonal_rl = np.array(sensor_data[3]) 

        # represents the (solution) matrix.
        self.matrix = np.empty((self.height, self.width), dtype=ScannerObject)
        for x in range(self.width):
            for y in range(self.height):
                self.matrix[y,x] = ScannerObject(x,y)

    # update sensor data (number of unassigned Trues) of ALL arrays that a certain element is part of (always 4)
    # minimum is 0
    def update_sensor_data(self, x, y):
        self.sensor_data_horizontal[y] = max(self.sensor_data_horizontal[y] - 1, 0)
        self.sensor_data_diagonal_lr[x+y] = max(self.sensor_data_diagonal_lr[x+y] - 1, 0)
        self.sensor_data_vertical[x] = max(self.sensor_data_vertical[x] - 1, 0)
        self.sensor_data_diagonal_rl[self.height-1-y+x] = max(self.sensor_data_diagonal_rl[self.height-1-y+x] - 1, 0)


    # if it's possible: fill the unassigned values of arr with either True of False, depending on the case
    # sensor_data: int - the number of unassigned elements in arr that need to be True
    # arr: array to look at 
    # return updated sensor_data
    def compare_and_fill(self, sensor_data_point, arr):
        # number of empty elements (unassigned Falses and Trues!)
        n_of_unassigned = 0
        for obj in arr:
            if obj.assignment == Assignment.UNASSIGNED:
                n_of_unassigned += 1

        # nothing to do here
        if n_of_unassigned == 0:
            return

        # Declare all unassigned as full
        if n_of_unassigned == sensor_data_point:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.FULL
                    self.update_sensor_data(obj.x, obj.y)

        # Declare all unassigned as empty
        elif sensor_data_point == 0:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.EMPTY
                #self.update_sensor_data(obj.x, obj.y)

    # mode: "run" or "debug"
    def fill_loop(self, mode="run"):
        while(mode == "run" and not self.is_done() or mode == "debug" and input() == ""):

            if mode == "debug":
                print(self)
                print(self.sensor_data_horizontal)
                print(self.sensor_data_diagonal_lr)
                print(self.sensor_data_vertical)
                print(self.sensor_data_diagonal_rl)
                
            diag_lr = [np.diagonal(np.fliplr(self.matrix), offset) for offset in range(self.width-1, 1-self.height-1, -1)]
            diag_rl = [np.diagonal(self.matrix, offset) for offset in range(1-self.height, self.width)]
            # Horizontals
            for i in range(self.height):
                self.compare_and_fill(self.sensor_data_horizontal[i], self.matrix[i,:])
            # LR-Diags
            for i in range(self.height + self.width - 1):
                self.compare_and_fill(self.sensor_data_diagonal_lr[i], diag_lr[i])
            # Verticals
            for i in range(self.width):
                self.compare_and_fill(self.sensor_data_vertical[i], self.matrix[:,i])
            # RL-Diags
            for i in range(self.height + self.width - 1):
                self.compare_and_fill(self.sensor_data_diagonal_rl[i], diag_rl[i])
        
        # if one of the two conditions is not met, a solution has not been found.
        if not (self.is_data_used() and self.is_all_assigned()):
            self.matrix = self.create_empty()
        
    def is_data_used(self):
        return not (np.any(self.sensor_data_horizontal != 0) or np.any(self.sensor_data_vertical != 0) or np.any(self.sensor_data_diagonal_lr != 0) or np.any(self.sensor_data_diagonal_rl != 0))

    def is_all_assigned(self):
        return not np.any(np.vectorize(lambda obj: obj.assignment == Assignment.UNASSIGNED)(self.matrix))
    
    def is_done(self):
        return self.is_data_used() or self.is_all_assigned()
    
    def create_empty(self):
        matrix = np.empty((self.height, self.width), dtype=ScannerObject)
        for x in range(self.width):
            for y in range(self.height):
                matrix[y,x] = ScannerObject(x,y)
                matrix[y,x].assignment = Assignment.EMPTY
        
        return matrix

    def __str__(self):
        str = ""
        for row in np.vectorize(lambda b: ' ' if b.assignment == Assignment.UNASSIGNED else '#' if b.assignment == Assignment.FULL else '.')(self.matrix):
            for char in row:
                print(char, end="")
            print()
        return str





if __name__ == "__main__":
    sensor_data = [[10,10,6,4,6,8,13,15,11,6],[0,1,2,2,2,2,4,5,5,6,7,6,5,6,6,5,5,6,6,3,2,2,1,0],[2,4,5,5,7,6,7,10,10,10,7,3,3,5,5],[0,0,1,3,4,4,4,4,3,4,5,7,8,8,9,9,6,4,4,2,0,0,0,0]]
    # sensor_data = [[3,3,3],[0,0,0,0,0],[1,2,3],[0,1,2,3,2]] # nonsense data

    scanner = Scanner(sensor_data)
    scanner.fill_loop()
    print(scanner)