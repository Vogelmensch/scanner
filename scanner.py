import numpy as np
from enum import Enum
import sys
from copy import deepcopy
from time import time

class Assignment(Enum):
    UNASSIGNED = 1
    EMPTY = 2
    FULL = 3

class ScannerObject:
    def __init__(self, x, y):
        self.assignment = Assignment.UNASSIGNED
        self.x = x
        self.y = y
    
    def __eq__(self, other):
        if other == None:
            return False
        return self.x == other.x and self.y == other.y and self.assignment == other.assignment

class Scanner:
    # initiates a scanner
    def __init__(self, sensor_data, termination_reasons, max_time = 0):
        self.sensor_data = sensor_data

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
        self.has_change_occured = True

        self.solutions_found = 0
        # solution we found through search
        self.search_solution = self.create_empty()

        # collects data about the reason why the program terminated
        self.termination_reasons = termination_reasons
        
        # time after initialization for measurement 
        self.start_time = time()
        
        # max time in seconds for solving
        self.max_time = max_time
        
        self.use_timeout = max_time > 0
        self.timed_out = False

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
        
        # Declare all unassigned as empty
        if sensor_data_point == 0:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.EMPTY
                    self.has_change_occured = True

        # Declare all unassigned as full
        elif n_of_unassigned == sensor_data_point:
            for obj in arr:
                if obj.assignment == Assignment.UNASSIGNED:
                    obj.assignment = Assignment.FULL
                    self.update_sensor_data(obj.x, obj.y)
                    self.has_change_occured = True



    # mode: "run" or "step"
    # in step mode: 
    #   - the user starts each loop iteration with a button press
    #   - each iteration, the current state gets printed
    def fill_loop(self, mode="run"):
        while(mode == "run" and not self.is_done() or mode == "step" and input() == "" and not self.is_done()):
            self.has_change_occured = False

            if mode == "step":
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


        # -- Now: What's the reason we left the loop? --

        # We found a solution!
        if self.is_data_used():
            if mode == "step":
                print("Found a solution:")
                print(self)
            self.termination_reasons["data used"] += 1

            # Increase solutions_found only if it's a new solution.
            if not np.all(np.equal(self.matrix, self.search_solution)):
                # a second solution has been found
                if mode == "step" and self.solutions_found > 0: 
                    print("This solution differs from the last\n")
                self.solutions_found += 1

            self.search_solution = deepcopy(self.matrix)

        # Fields may all be assigned, but there is data left 
        # -> contradiction
        elif self.is_all_assigned():
            self.termination_reasons["all assigned"] += 1
            self.matrix = self.create_empty()
        
        # We're stuck!
        # -> perform local search: assign a variable and continue
        elif not self.has_change_occured:
            if mode == "step":
                print("Starting search...")
                
            # indices of unassigned fields
            indices_of_unassigned = np.argwhere(np.vectorize(lambda obj: obj.assignment == Assignment.UNASSIGNED)(self.matrix))

            for idx in indices_of_unassigned:
                if self.timed_out:
                    return
                # recursive calls:
                for assignment in [Assignment.EMPTY, Assignment.FULL]:
                    self.search_in_branch(idx, mode, assignment)
                    if self.solutions_found > 1:
                        # the solution is ambiguous -> leave loop
                        self.matrix = self.create_empty()
                        return 
            self.matrix = self.search_solution

    # assign a variable and call fill_loop recursively
    # clean up afterwards
    def search_in_branch(self, idx, mode, value):
        # abort search immediately if out of time
        if self.use_timeout and time() - self.start_time > self.max_time:
            self.timed_out = True
            return
        
        # save old data
        old_matrix = deepcopy(self.matrix)
        old_sensor_data_horizontal = self.sensor_data_horizontal.copy()
        old_sensor_data_diagonal_lr = self.sensor_data_diagonal_lr.copy()
        old_sensor_data_vertical = self.sensor_data_vertical.copy()
        old_sensor_data_diagonal_rl = self.sensor_data_diagonal_rl.copy()

        # assign variable
        self.matrix[tuple(idx)].assignment = value
        self.has_change_occured = True
        if value == Assignment.FULL:
            self.update_sensor_data(idx[1], idx[0])
        self.fill_loop(mode)

        # re-assign old data
        self.matrix = old_matrix
        self.sensor_data_horizontal = old_sensor_data_horizontal
        self.sensor_data_diagonal_lr = old_sensor_data_diagonal_lr
        self.sensor_data_vertical = old_sensor_data_vertical
        self.sensor_data_diagonal_rl = old_sensor_data_diagonal_rl

    def is_data_used(self):
        return not (np.any(self.sensor_data_horizontal != 0) or np.any(self.sensor_data_vertical != 0) or np.any(self.sensor_data_diagonal_lr != 0) or np.any(self.sensor_data_diagonal_rl != 0))

    def is_all_assigned(self):
        return not np.any(np.vectorize(lambda obj: obj.assignment == Assignment.UNASSIGNED)(self.matrix))
    
    # Check whether we're done
    def is_done(self):
        return self.is_data_used() and self.solutions_found > 0 or self.is_all_assigned() or not self.has_change_occured
    
    def create_empty(self):
        matrix = np.empty((self.height, self.width), dtype=ScannerObject)
        for x in range(self.width):
            for y in range(self.height):
                matrix[y,x] = ScannerObject(x,y)
                matrix[y,x].assignment = Assignment.EMPTY
        return matrix
        
    def __str__(self):
        str = ""
        for row in np.vectorize(lambda b: '  ' if b.assignment == Assignment.UNASSIGNED else '# ' if b.assignment == Assignment.FULL else '. ')(self.matrix):
            for char in row:
                print(char, end="")
            print()
        return str


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:\n\tpython scanner.py <input-file> [options]\n")
        print("Options:\n\t-s  use step-mode")
        print("\t-c  print collected termination data")
        sys.exit(1)

    file_path = sys.argv[1]
    arg = "step" if "-s" in sys.argv else "run"
    collecting = "-c" in sys.argv
    use_timeout = "-t" in sys.argv
    max_time = 0.01

    try:
        f = open(file_path)
    except FileNotFoundError:
        print(f"File \"{file_path}\" not found.")
        sys.exit(1)
    else:
        with f:
            n_layers = int(f.readline())
            termination_reasons = {"data used": 0, "all assigned": 0, "no change": 0}
            n_timeouts = 0

            for layer in range(n_layers):
                sensor_data = []
                for _ in range(4):
                    next_line = f.readline().split(" ")
                    sensor_data.append(list(map(int, next_line)))
            
                if arg == "step":
                    print(f"Layer {layer}:")

                scanner = Scanner(sensor_data, termination_reasons, max_time if use_timeout else 0)
                scanner.fill_loop(arg)
                
                if use_timeout and scanner.timed_out:
                    print(time() - scanner.start_time)
                    n_timeouts += 1
                
                if arg == "run":
                    print(scanner)
                
                if arg == "step":
                    print(scanner.sensor_data_horizontal)
                    print(scanner.sensor_data_diagonal_lr)
                    print(scanner.sensor_data_vertical)
                    print(scanner.sensor_data_diagonal_rl)
                    print()
                    
                print()
                
            
            if collecting:
                print(termination_reasons)
                
            if use_timeout:
                print(f"ran {n_layers} layers")
                print(f"timed out {n_timeouts} times after {max_time} seconds")
                print(f"rate: {n_timeouts / n_layers * 100} %")