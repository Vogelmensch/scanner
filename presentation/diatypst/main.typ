#import "@preview/diatypst:0.5.0": *

#show: slides.with(
  title: "Scanner", // Required
  subtitle: "Selected Fun Problems of the ACM Programming Contest SS25",
  date: "04.06.2025",
  authors: "David Knöpp",

  // Optional Styling (for more / explanation see in the typst universe)
  ratio: 16 / 9,
  layout: "medium",
  title-color: rgb("#2e8340"),
  toc: false,
  count: "number",
  footer: false,
)

#let font = "libertinus serif"

#let dual_matrix(image_link, code) = {
  grid(
    align: left + horizon,
    //rows: (50%, 50%),
    columns: (65%, 35%),
    [#image(image_link, height: 80%)],
    code,
  )
}

#let live_demo() = {
  align(center + horizon, image("matrix-laptop.drawio.svg", height: 50%))
}

== About questions

- Please ask questions if you do not understand an important aspect
- Otherwise, please save your questions for the discussion after the presentation

= Problem Definition

== Result Matrix

#align(center + horizon)[
  #image("matrix.svg", height: 80%)
]

== Result Matrix

#align(center + horizon)[
  #image("matrix-filled.svg", height: 80%)
]

== Result Matrix

#dual_matrix(
  "matrix-filled.svg",
  [
    #text(
      font: "DejaVu Sans Mono",
      "
      . # # .
      . # # .
      # # # .
      # # . .",
    )\
    \
    This is our actual output.
  ],
)

#align(center, "But what is our input?")

== Getting the input

#dual_matrix(
  "matrix-Matrix Horiz Numbers.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    2 2 3 2
  ],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix DiagLR Numbers.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    2 2 3 2\
    0 1 3 3 2 0 0\
  ],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix Vert Numbers.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    2 2 3 2\
    0 1 3 3 2 0 0\
    2 4 3 0\
  ],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix DiagRL Numbers.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    2 2 3 2\
    0 1 3 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Getting the input

#grid(
  columns: (30%, 40%, 30%),
  align: horizon,
  rows: (10%, 80%, 10%),
  [], [], [],
  [],
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    0 1 3 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
  [],

  [], [],
)

== Live Demo

#live_demo()


= Solution

== Tools

- Python
  - Personal experience
- Numpy
  - Convenient and efficient matrix operations
  - Personal experience


== Example

#let marked(s) = text(fill: red, s)

#dual_matrix(
  "matrix-grey_horiz.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("2 2 3 2")\
    0 1 3 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey_diag_lr.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    #marked("0 1 3 3 2 0 0")\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey-zeros.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    #marked("0") 1 3 3 2 #marked("0 0")\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey-zeros-assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    #marked("0") 1 3 3 2 #marked("0 0")\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey-three.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    0 1 #marked("3") 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey-three-assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    0 1 #marked("3") 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-first-assignments.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    0 1 3 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-update-values-before.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 #marked("3") 2\
    0 1 #marked("3") 3 2 0 0\
    #marked("2") 4 3 0\
    1 #marked("2") 1 2 2 1 0\
  ],
)

== Example



#dual_matrix(
  "matrix-update-values-before.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("2") #marked("2") #marked("3") 2\
    0 1 #marked("3") 3 2 0 0\
    #marked("2") #marked("4") #marked("3") 0\
    1 #marked("2") 1 #marked("2") 2 #marked("1") 0\
  ],
)

== Example



#dual_matrix(
  "matrix-update-values-after.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("1") #marked("1") #marked("2") 2\
    0 1 #marked("0") 3 2 0 0\
    #marked("1") #marked("3") #marked("2") 0\
    1 #marked("1") 1 #marked("1") 2 #marked("0") 0\
  ],
)

== Example

#dual_matrix(
  "matrix-grey_horiz.drawio.svg",
  [

  ],
)

== Example



#dual_matrix(
  "matrix-grey_horiz_after.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("1 1 2 2")\
    0 1 0 3 2 0 0\
    1 3 2 0\
    1 1 1 1 2 0 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey_horiz_after_focus.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    1 1 #marked("2 2")\
    0 1 0 3 2 0 0\
    1 3 2 0\
    1 1 1 1 2 0 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey_horiz_after_focus_assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    1 1 #marked("2 2")\
    0 1 0 3 2 0 0\
    1 3 2 0\
    1 1 1 1 2 0 0\
  ],
)

== Example



#dual_matrix(
  "matrix-grey_horiz_after_focus_assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    1 1 #marked("2 2")\
    0 1 0 #marked("3 2") 0 0\
    #marked("1 3 2") 0\
    #marked("1 1 1 1") 2 0 0\
  ],
)



== Example

#dual_matrix(
  "matrix-grey_horiz_after_assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    1 1 #marked("0 0")\
    0 1 0 #marked("1 0") 0 0\
    #marked("0 1 1") 0\
    #marked("0 0 0 0") 2 0 0\
  ],
)

== Example

#dual_matrix(
  "matrix-last_step.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    1 1 0 0\
    0 1 0 1 0 0 0\
    #marked("0 1 1 0")\
    0 0 0 0 2 0 0\
  ],
)

== Example

#dual_matrix(
  "matrix-last_step_assigned.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("1 1") 0 0\
    0 #marked("1") 0 #marked("1") 0 0 0\
    #marked("0 1 1 0")\
    0 0 0 0 #marked("2") 0 0\
  ],
)

== Example

#dual_matrix(
  "matrix-last_step_assigned_zeros.drawio.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    #marked("0 0") 0 0\
    0 #marked("0") 0 #marked("0") 0 0 0\
    #marked("0 0 0 0")\
    0 0 0 0 #marked("0") 0 0\
  ],
)

== Example

#dual_matrix(
  "matrix-filled.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    0 0 0 0\
    0 0 0 0 0 0 0\
    0 0 0 0\
    0 0 0 0 0 0 0\
  ],
)

// == Example

// #import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

// #let fontsize = 6pt

// #set text(size: fontsize)
// #let c(s) = text(size: fontsize, font: "DejaVu Sans Mono", s)

// #grid(
//   rows: (50%, 50%),
//   align: horizon + center,
//   [#diagram(
//       debug: 1,
//       node-stroke: 1pt,
//       node((0, 0), c("compare_and_fill(sensor_data_point, array)"), corner-radius: 2pt, extrude: (0, 3)),
//       edge("-|>"),
//       node(
//         (0, 1),
//         align(center)[
//           get number of\ unassigned cells\ n_unassigned
//         ],
//       ),
//       edge((0, 1), (-1, 2), "-|>", label: c("sensor_data_point == 0")),
//       node((-1, 2), "Declare all " + c("unassigned") + " as " + c("empty")),
//       edge((0, 1), (1, 2), "-|>", label: c("sensor_data_point == n_unassigned")),
//       node((1, 2), "Declare all " + c("unassigned") + " as " + c("full")),
//     )
//   ],
//   [

//   ],
// )

== Fill known cells

```Python
def compare_and_fill(sensor_data_point, arr):
        # number of unassigned elements
        n_of_unassigned = n_of_unassigned(arr)

        # Declare all unassigned as empty
        if sensor_data_point == 0:
            for cell in arr:
                if cell == UNASSIGNED:
                    cell = EMPTY

        # Declare all unassigned as full
        elif sensor_data_point == n_of_unassigned:
            for cell in arr:
                if cell == UNASSIGNED:
                    cell = FULL
                    update_sensor_data(cell.x, cell.y)

```

== Main Loop

```Python
while(not is_done()):
            diag_lr = get_diagonal_lr(matrix)
            diag_rl = get_diagonal_rl(matrix)

            # Horizontals
            for i in range(height):
                compare_and_fill(sensor_data_horizontal[i], matrix[i,:])
            # LR-Diags
            for i in range(height + width - 1):
                compare_and_fill(sensor_data_diagonal_lr[i], diag_lr[i])
            # Verticals
            for i in range(width):
                compare_and_fill(sensor_data_vertical[i], matrix[:,i])
            # RL-Diags
            for i in range(height + width - 1):
                compare_and_fill(sensor_data_diagonal_rl[i], diag_rl[i])
```

== Are we done?

- Does `compare_and_fill` always find a solution?
- What if there is no solution?
- What if there are multiple solutions?

== Are we done?

- Does `compare_and_fill` always find a solution?
- What if there is no solution?
- What if there are multiple solutions?

\

Let's first answer a different question:
- How do we know whether we found a solution?


== How do we know whether we found a solution?

#dual_matrix(
  "matrix-filled.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    0 0 0 0\
    0 0 0 0 0 0 0\
    0 0 0 0\
    0 0 0 0 0 0 0\
  ],
)
#align(center, "All input_datas-entries are zero")

== Invalid state

#dual_matrix(
  "matrix-filled.svg",
  [
    #set text(font: "DejaVu Sans Mono")
    1\
    0 0 0 0\
    0 0 0 0 0 0 0\
    0 #marked("1") 0 0\
    0 0 0 0 0 0 0\
  ],
)
#align(center, "Every cell is assigned, but there is one input_data-entry left!")
#align(center, $=>$ + " contradiction")

== Termination Condition

1. Check whether all `input_data` is zero
```Python
def is_data_used(sensor_data):
        return not np.any(sensor_data != 0)
```

2. Check whether all cells are assigned
```Python
def is_all_assigned(matrix):
        return not np.any(matrix.cell == UNASSIGNED)
```

3. Check whether we are done
```Python
def is_done():
        return is_data_used(sensor_data) or is_all_assigned(matrix)
```

== Demo: No Solution

#live_demo()

== Multiple solutions

- We assign `EMPTY` or `FULL` *only if* we know a state for certain
- $=>$ with `compare_and_fill`, we can only detect *single* solutions
- If multiple solutions exist for a given input $=>$ get stuck

== Multiple Solutions: Local Search

```Python
# value is either FULL or EMPTY
def search_in_branch(idx, value, matrix, sensor_data):
        # save old data
        old_matrix = matrix.copy()
        old_sensor_data = sensor_data.copy()

        # assign variable
        matrix[idx] = value
        if value == FULL:
            update_sensor_data(idx[1], idx[0])
        fill_loop()

        # re-assign old data
        matrix = old_matrix
        sensor_data = old_sensor_data
```

== Multiple Solutions: Local Search

```Python
# ... inside fill_loop()
if not has_change_occured:
            # indices of unassigned fields
            indices_of_unassigned = np.argwhere(matrix.cell == UNASSIGNED)

            for idx in indices_of_unassigned:
                # recursive calls
                for assignment in [EMPTY, FULL]:
                    search_in_branch(idx, value, matrix, sensor_data)
                    if solutions_found > 1:
                        # the solution is ambiguous -> leave loop
                        return
```

== Demo: Local Search

#live_demo()

== Conclusion

*Does the algorithm always find a solution?*\
Answer: If it exists: Yes! But...
- ... we can get stuck $=>$ perform local search\ \

*What if there is no solution?*\
Answer: Data will be contradictory\ \

*What if there are multiple solutions?*\
Answer: We get stuck $=>$ perform local search

= Discussion

== Time Complexity

- Take a matrix of dimension $(n times m)$
- Worst case: Local search from the beginning
- Worst case time complexity: $cal(O)(2^(n dot m))$

== Time Complexity: Using matrix property

- Problem Definition: *Body* Scanner
- $=>$ Matrix property: Most `FULL` cells are neighbored

#text(
  font: "DejaVu Sans Mono",
  "
      . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . .
      . . . . . # # . . . . . . . .
      . . . . . # # # # # # # . . .
      . . . . . # # # # # # # # # .
      . . . . # # # # # # # # . # .
      . . . . . # # # # # . . . . .
      . . . . . . # # # # . . . . .
      . . . . . . # # . # # . . . .
      . . . . . . . . . . . . . . .",
)

== Time Complexity: Using matrix property

- Problem Definition: *Body* Scanner
- $=>$ Matrix property: Most `FULL` cells are neighbored

#text(
  font: "DejaVu Sans Mono",
  "
      . . . . . . . . . # # . . . .
      . . . . . . . . # # # # # # .
      . . . . . . . # # # # # . . .
      . . . . . . . # # # # . . # .
      . . . . . . # # # # # # # # #
      . . . . . # # # # # # # # # #
      . . . . . # # # # # # # # # #
      . . . . . # . . # # # # # # #
      . . . . . . . . . # # # . . .
      . . . . . . . . . . # . . . . ",
)

== Time Complexity: Using matrix property

- Problem Definition: *Body* Scanner
- $=>$ Matrix property: Most `FULL` cells are neighbored

#grid(
  stroke: none,
  columns: (60%, 40%),
  [#text(
      font: "DejaVu Sans Mono",
      "
      . . . . . . . . . # # . . . .
      . . . . . . . . # # # # # # .
      . . . . . . . # # # # # . . .
      . . . . . . . # # # # . . # .
      . . . . . . # # # # # # # # #
      . . . . . # # # # # # # # # #
      . . . . . # # # # # # # # # #
      . . . . . # . . # # # # # # #
      . . . . . . . . . # # # . . .
      . . . . . . . . . . # . . . . ",
    )],
  [
    - `compare_and_fill` uses this property.
    - Reduces search-space significantly.
  ],
)




== Demo: Chunk Inputs

#live_demo()

== Algorithm Justification

*Experiment*:
1. Generate 10000 random inputs of dimension $(10 times 15)$
2. Run `scanner.py`: Abort after $t_max = 0.01s$
3. Measure number of timeouts

== Algorithm Justification

*Experiment*:
1. Generate 10000 random inputs of dimension $(10 times 15)$
2. Run `scanner.py`: Abort after $t_max = 0.01s$
3. Measure number of timeouts
\
*Results*:

#table(
  columns: 2,
  align: center,
  [matrix type],[timeout-rate],
  [random],[99.69%],
  [chunk],[1.47%]
)

== Algorithm Justification

*Experiment*:
1. Generate 10000 random inputs of dimension $(10 times 15)$
2. Run `scanner.py`: Abort after $t_max = 0.01s$
3. Measure number of timeouts
\
*Results*:

#table(
  columns: 2,
  align: center,
  [matrix type],[timeout-rate],
  [random],[99.69%],
  [chunk],[1.47%]
)
\
$=>$ Most inputs can be solved in sub-exponential time!


== Summary

#grid(
  stroke: none,
  columns: (30%, 70%),
  align: left + horizon,
  [
    Input:\
    #set text(font: "DejaVu Sans Mono")
    1\
    2 2 3 2\
    0 1 3 3 2 0 0\
    2 4 3 0\
    1 2 1 2 2 1 0\

    #set text(font: font)
    Output:
    #image("matrix-filled.svg", height: 40%)
  ],
  ```Python
  def compare_and_fill(sensor_data_point, arr):
          # number of unassigned elements
          n_of_unassigned = n_of_unassigned(arr)
          # Declare all unassigned as empty
          if sensor_data_point == 0:
              for cell in arr:
                  if cell == UNASSIGNED:
                      cell = EMPTY

          # Declare all unassigned as full
          elif sensor_data_point == n_of_unassigned:
              for cell in arr:
                  if cell == UNASSIGNED:
                      cell = FULL
                      update_sensor_data(cell.x, cell.y)

  ```,
)
