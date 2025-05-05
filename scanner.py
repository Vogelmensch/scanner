import numpy as np
from enum import Enum
import sys

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
    def __init__(self, sensor_data, termination_reasons):
        self.height = len(sensor_data[0])
        self.width = len(sensor_data[2])

        # Load sensor data
        # Interpreting sensor data as "number of yet unassigned FULL-Values"
        self.sensor_data_horizontal = np.array(sensor_data[0])
        self.sensor_data_diagonal_lr = np.array(sensor_data[1])
        self.sensor_data_vertical = np.array(sensor_data[2])
        self.sensor_data_diagonal_rl = np.array(sensor_data[3]) 

        # represents the (solution) matrix.
        self.matrix = np.empty((self.height, self.width), dtype=ScannerObject)
        for x in range(self.width):
            for y in range(self.height):
                self.matrix[y,x] = ScannerObject(x,y)
        
        # Tracks whether a change occured for each iteration
        # -> catches unsolvable problems
        self.changeOccured = True

        # collects data about the reason why the program terminated
        self.termination_reasons = termination_reasons

    # update sensor data (number of unassigned Trues) of ALL arrays that a certain element is part of (always 4)
    # minimum is 0
    def update_sensor_data(self, x, y):
        self.sensor_data_horizontal[y] = max(self.sensor_data_horizontal[y] - 1, 0)
        self.sensor_data_diagonal_lr[x+y] = max(self.sensor_data_diagonal_lr[x+y] - 1, 0)
        self.sensor_data_vertical[x] = max(self.sensor_data_vertical[x] - 1, 0)
        self.sensor_data_diagonal_rl[self.height-1-y+x] = max(self.sensor_data_diagonal_rl[self.height-1-y+x] - 1, 0)

    # if it's possible: fill the unassigned values of arr with either FULL or EMPTY, depending on the case
    # sensor_data_point: int - the number of unassigned elements in arr that need to be FULL
    # arr: array to inspect
    def compare_and_fill(self, sensor_data_point, arr):
        # number of unassigned elements
        n_of_unassigned = 0
        for obj in arr:
            if obj.assignment == Assignment.UNASSIGNED:
                n_of_unassigned += 1

        # if all elements are assigned, there is nothing to do here
        if n_of_unassigned == 0:
            return

        # Declare all unassigned as full
        if n_of_unassigned == sensor_data_point:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.FULL
                    self.update_sensor_data(obj.x, obj.y)
                    self.changeOccured = True

        # Declare all unassigned as empty
        elif sensor_data_point == 0:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.EMPTY
                    self.changeOccured = True

    # mode: "run" or "debug"
    def fill_loop(self, mode="run"):
        while(mode == "run" and not self.is_done() or mode == "debug" and input() == "" and not self.is_done()):
            self.changeOccured = False

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
    
    # Check whether we're done
    # collect data about the reason
    def is_done(self):
        is_done = self.is_data_used() or self.is_all_assigned() or not self.changeOccured
        if is_done and self.is_data_used():
            self.termination_reasons["data used"] += 1
        if is_done and self.is_all_assigned():
            self.termination_reasons["all assigned"] += 1
        if is_done and not self.changeOccured:
            self.termination_reasons["no change"] += 1
        return is_done
    
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
    if len(sys.argv) < 2:
        print("Usage:\n\tpython scanner.py <input-file>\n")
        print("Options:\n\t-d  use debug-mode")
        sys.exit(1)

    file_path = sys.argv[1]
    arg = "debug" if len(sys.argv) > 2 and sys.argv[2] == "-d" else "run"


    try:
        f = open(file_path)
    except FileNotFoundError:
        print(f"File \"{file_path}\" not found.")
        sys.exit(1)
    else:
        with f:
            n_layers = int(f.readline())
            termination_reasons = {"data used": 0, "all assigned": 0, "no change": 0}

            for layer in range(n_layers):
                sensor_data = []
                for _ in range(4):
                    next_line = f.readline().split(" ")
                    sensor_data.append(list(map(int, next_line)))
            
                if arg == "debug":
                    print(f"Layer {layer}:")

                scanner = Scanner(sensor_data, termination_reasons)
                scanner.fill_loop(arg)
                print(scanner)

            print(termination_reasons)