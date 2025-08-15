#import "template.typ": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, edge, node


// this show rule enables line numbering in code blocks
#show raw.where(block: true): code => {
  show raw.line: line => {
    box(width: .6em, align(right, text(fill: gray)[#line.number]))
    h(1em)
    line.body
  }
  block(
    fill: silver.lighten(75%),
    inset: 8pt,
    radius: 5pt,
    text(fill: rgb("#222222"), code),
  )
}

#show figure.where(
  kind: table,
): set figure.caption(position: top)

#show link: set text(fill: rgb(165, 30, 55))


// filled-cells color
#let FULL_COLOR = aqua

// scanner-cell
#let scell(x, y, isFull, col: FULL_COLOR) = node(
  (x, y),
  width: 2em,
  height: 2em,
  shape: rect,
  stroke: 1pt,
  fill: if isFull { col } else { white },
  snap: false,
)

// scanner-edge
#let sedge(x0, y0, x1, y1) = edge(
  (x0, y0),
  (x1, y1),
  "->",
  layer: 1,
  floating: true,
  stroke: (paint: red, thickness: 0.7pt),
)

#let smatrix_empty() = diagram(
  debug: false,
  spacing: (0pt, 0pt),

  // cells
  scell(0, 0, false),
  scell(0, 1, false),
  scell(0, 2, false),
  scell(0, 3, false),
  scell(1, 0, false),
  scell(1, 1, false),
  scell(1, 2, false),
  scell(1, 3, false),
  scell(2, 0, false),
  scell(2, 1, false),
  scell(2, 2, false),
  scell(2, 3, false),
  scell(3, 0, false),
  scell(3, 1, false),
  scell(3, 2, false),
  scell(3, 3, false),
)

#let smatrix_with_object() = diagram(
  debug: false,
  spacing: (0pt, 0pt),

  // cells
  scell(0, 0, false),
  scell(0, 1, false),
  scell(0, 2, false),
  scell(0, 3, false),
  scell(1, 0, false),
  scell(1, 1, false),
  scell(1, 2, false),
  scell(1, 3, false),
  scell(2, 0, false),
  scell(2, 1, false),
  scell(2, 2, false),
  scell(2, 3, false),
  scell(3, 0, false),
  scell(3, 1, false),
  scell(3, 2, false),
  scell(3, 3, false),

  // object
  node((0.75, 2.25), radius: 1em, shape: circle, layer: 1, fill: FULL_COLOR),
  node((1.5, 1.5), radius: 1.5em, shape: circle, layer: 1, fill: FULL_COLOR),
  node((1.5, 0.5), radius: 1em, shape: circle, layer: 1, fill: FULL_COLOR),
)

// basic matrix
#let smatrix(args) = diagram(
  debug: false,
  spacing: (0pt, 0pt),

  // cells
  scell(0, 0, false),
  scell(0, 1, false),
  scell(0, 2, true),
  scell(0, 3, true),
  scell(1, 0, true),
  scell(1, 1, true),
  scell(1, 2, true),
  scell(1, 3, true),
  scell(2, 0, true),
  scell(2, 1, true),
  scell(2, 2, true),
  scell(2, 3, false),
  scell(3, 0, false),
  scell(3, 1, false),
  scell(3, 2, false),
  scell(3, 3, false),

  args,
)

#let smatrix_horizontal = smatrix((
  // left annotations
  node((-1, 0), [2]),
  node((-1, 1), [2]),
  node((-1, 2), [3]),
  node((-1, 3), [2]),
  sedge(-1, 0, 4, 0),
  sedge(-1, 1, 4, 1),
  sedge(-1, 2, 4, 2),
  sedge(-1, 3, 4, 3),
  // invisible nodes for equal borders
  node((4, 4), " "),
  node((4, -1), " "),
))

#let smatrix_vertical = smatrix((
  // bottom annotations
  node((0, 4), [2]),
  node((1, 4), [4]),
  node((2, 4), [3]),
  node((3, 4), [0]),
  sedge(0, 4, 0, -1),
  sedge(1, 4, 1, -1),
  sedge(2, 4, 2, -1),
  sedge(3, 4, 3, -1),
  // invisible nodes for equal borders
  node((-1, 4), " "),
  node((4, -1), " "),
))

#let diag_off = 0.25

#let smatrix_diag_lr = smatrix((
  // diagonal annotations
  node((-1, 1), [0]),
  node((-1, 2), [1]),
  node((-1, 3), [3]),
  node((-1, 4), [3]),
  node((0, 4), [2]),
  node((1, 4), [0]),
  node((2, 4), [0]),
  sedge(-1, 1, 1 - diag_off, -1 + diag_off),
  sedge(-1, 2, 2 - diag_off, -1 + diag_off),
  sedge(-1, 3, 3 - diag_off, -1 + diag_off),
  sedge(-1, 4, 4 - diag_off, -1 + diag_off),
  sedge(0, 4, 4 - diag_off, 0 + diag_off),
  sedge(1, 4, 4 - diag_off, 1 + diag_off),
  sedge(2, 4, 4 - diag_off, 2 + diag_off),
  // invisible nodes for equal borders
  node((0, -1), " "),
  node((4, 4), " "),
))

#let smatrix_diag_rl = smatrix((
  // diagonal annotations
  node((1, 4), [1]),
  node((2, 4), [2]),
  node((3, 4), [1]),
  node((4, 4), [2]),
  node((4, 3), [2]),
  node((4, 2), [1]),
  node((4, 1), [0]),
  sedge(1, 4, -1 + diag_off, 2 + diag_off),
  sedge(2, 4, -1 + diag_off, 1 + diag_off),
  sedge(3, 4, -1 + diag_off, 0 + diag_off),
  sedge(4, 4, -1 + diag_off, -1 + diag_off),
  sedge(4, 3, 0 + diag_off, -1 + diag_off),
  sedge(4, 2, 1 + diag_off, -1 + diag_off),
  sedge(4, 1, 2 + diag_off, -1 + diag_off),
  // invisible nodes for equal borders
  node((-1, 4), " "),
  node((4, -1), " "),
))




#show: acmart.with(
  format: "acmsmall",
  // Text in "" is taken literally, while text in [] is "interpreted", e.g., --- is converted to an m-dash
  title: [No Need for Search to Solve the Scanner],
  subtitle: "The ICPC Scanner Problem",
  authors: {
    (
      (
        name: "David Knöpp",
        email: "david.knoepp@student.uni-tuebingen.de",
        affiliation: (
          institution: "University of Tübingen",
          country: "Germany",
        ),
      ),
    )
  },

  abstract: [
    ACM releases several programming problems for ICPC every year. Problem "5168 - Scanner" provides the depth of a three-dimensional body as input, and demands the discrete reconstruction of the body as output. Exhaustive search fails to solve the problem in reasonable time. We propose a method that greatly reduces the search space for Exhaustive Search by exploiting a spatial property of the wanted body. Applying this method to randomly generated, valid inputs allows to fully avoid searching for $~ 98.5 %$ of inputs.
  ],
  ccs: none,
  keywords: ("ICPC", "Scanner", "Search"),
  copyright: "studentpaper",

  acmYear: 2025,
)


= Introduction <intro>

The Scanner Problem introduces a scenario in which a three-dimensional body has been scanned for its depth. The task is to reconstruct the body from those depth-values alone. We explain the problem in detail in @encoding.

The intuitive solution to this problem is to search through all possible assignments discretized matrices, through exhaustive or local search. This approach is not ideal for two reasons.
1. Exhaustive Search has an exponential time complexity, which makes it unusable for bigger matrices (especially the ones features in the original problem description).
2. Local Search cannot identify invalid inputs.
We cannot eliminate the need for search entirely (see @exhaustive). Still, we can view the problem at a different light.
- The results that we are searching for share a common property, which we call the "chunk-property". The chunk-property can be exploited to assign large groups of cells at once with absolute certainty (see @chunk).
- Some inputs may have zero or multiple solutions. We found two conditions that allow for handling those kind of inputs early (see @iterate).
- We performed an exeriment to quantize the number of inputs that can be solved in this way. We generated random, valid data and checked the number of inputs where the program did not time-out, i.e. where it stuck at local search for too long. The results show that we can solve $~ 98.5 %$ of problems in sub-exponential time (see @analysis).
While we are able to avoid exhaustive search for most inputs, some inputs still require a full search. Thus, further research for better search algorithms is still required.


= Encoding a 3d body <encoding>

To understand the scanner-algorithm, we must first understand the semantics of the code we are solving. In this section, we start with a three-dimensional body and encode it step by step, to end up with a set of integer-arrays.

*Step one*: Along the vertical axis, the body is divided into a finite set of two-dimensional slices. Each slice is viewed as constant in depth along the vertical axis, i.e. having a discrete vertical depth of one. We then encode every slice independently of the others. All subsequent steps are applied to each slice individually. For the rest of the paper, we focus on one slice only for better understandability.

*Step two*: The slice is discretized as a grid of $h times w$ cells. A cell's state is binary-encoded: if the cell contains _any_ portion of the body, the cell is encoded as `FULL`. Otherwise, it is encoded as `EMPTY`. See @discretization.

*Step three*: The grid of cells is now being measured for its depth along four directions. See @scanning for a visualization. The directions are:
- horizontal
- first diagonal (from bottom left to top right)
- vertical, and
- second diagonal (from bottom right to top left).
For each of those directions, the discretized body's depth is measured at all possible locations. For a grid of dimension $h times w$, this yields four arrays with $h$, $h + w + 1$, $w$, and $h + w + 1$ entries respectively. For our example, the resulting arrays are shown in @encoded. Those four arrays make up the encoded slice.


#figure(
  placement: bottom,
  caption: [Discretization of an object],
  diagram(
    spacing: 5em,
    node((0, 0), smatrix_with_object()),
    node((1, 0), smatrix(none)),
    edge((0, 0), (1, 0), "->"),
  ),
) <discretization>


#figure(
  placement: bottom,
  caption: [Encoding the object by scanning its depth],
  grid(
    rows: (auto, auto),
    columns: (auto, auto),
    smatrix_horizontal, smatrix_diag_lr, 
    smatrix_vertical, smatrix_diag_rl,
  ),
) <scanning>


#figure(
  placement: bottom,
  caption: [Arrays encoding the slice],
  ```Python
  [2, 2, 3, 2], # horizontal
  [0, 1, 3, 3, 2, 0, 0], #left-right-diagonals
  [2, 4, 3, 0], # vertical
  [1, 2, 1, 2, 2, 1, 0] # right-left-diagonals
  ```,
) <encoded>


= Reconstructing a slice <reconstruct>

We are given two integer-arrays of lengths $m$ and $n$, and two integer-arrays of lengths $m + n + 1$, all representing the depth of the object in the four possible directions. We want to reconstruct the discretized image from this data only. In this chapter, we explain the algorithmic approach we found to be most effective.


== Exhaustive Search <exhaustive>

The dimension of the resulting matrix is known from the lengths of the horizontal and vertical input arrays. The possible values to fill the matrix with are also known (`EMPTY` and `FULL`). Thus, we can simply try out all possible solutions, calculate the depth of the resulting object at the four given directions, and compare those to the input arrays.

This approach is obviously not optimal, as it has exponential time complexity. However, we will need to incorporate exhaustive search into our solution to guarantee completeness, as we will see later.


== Exploiting the chunk property <chunk>

Our goal is to reduce the search space such that the slice can be reconstructed in sub-exponential time. To achieve this, we exploit a property our resulting matrices have. We call this the chunk property.

We know that we are recreating images of two-dimensional bodies. The term "body" is interpreted as: Most of the `FULL`-valued cells of the matrix are located next to each. What we do not expect, for example, is a noisy image, where the value of each cell is decided independently of its neighbors.

From the chunk property follows that some sub-arrays (verticals, horizontals or diagonals) of the matrix may be completely filled with `EMPTY`-values. The respective depth for this sub-array must then be zero. Searching for zeros in the input thus leads to complete knowledge of all values in the respective sub-array.

From the chunk property also follows that some sub-arrays may be completely filled with `FULL`-values. The respective depth for this sub-array must then be equal to the length of the sub-array. Searching for values of maximal depth in the input thus leads to complete knowledge of all values in the respective sub-array as well.

@compare-and-fill shows the code implementing `compare_and_fill`, the function which fills all cells whose state we can derive logically by the chunk property. Its parameters are
- `sensor_data_point`, a single depth-value from the input
- `arr`, the corresponding sub-array of the matrix.
The function does exactly what has been described above: if `sensor_data_point` equals zero, it assigns all unassigned values of `arr` to `EMPTY`. If `sensor_data_point` equals the number of unassigned values of `arr`, it assigns all those values to `FULL`.

As any cell belongs to exactly four sub-arrays (one for each direction), on assignment of `FULL` to one cell, each depth-value for all of those four sub-arrays need to be updated. This is what the function call `update_sensor_data` in line 13 does.


#figure(
  placement: auto,
  caption: [Using the chunk property],
  //placement: top,
  ```Python
  def compare_and_fill(sensor_data_point, arr):
      n_of_unassigned = n_of_unassigned(arr)

      if sensor_data_point == 0:
          for cell in arr:
              if cell == UNASSIGNED:
                  cell = EMPTY

      elif sensor_data_point == n_of_unassigned:
          for cell in arr:
              if cell == UNASSIGNED:
                  cell = FULL
                  update_sensor_data(cell)
  ```,
) <compare-and-fill>


== Exactly one solution <iterate>

How do we know whether we found a valid solution? Consider the call to `update_sensor_data` in @compare-and-fill. With this call, all relevant input values are being updated after an assignment of `FULL` to a cell. Thus, when a valid solution has been found, the entire input has to be zero. This is the exact condition we need to check in order to find a valid assignment. If, at one point, all cell-entries have been assigned to `FULL` or `EMPTY`, and simultaneously, not all inputs are zero, then the assignment that has been found is invalid.

To solve the problem, all we have to do now is applying `compare_and_fill` to all pairs of depths and sub-arrays iteratively until we found a solution, see @fill-loop. However, we are not guaranteed to find a solution just yet. This is due to the fact that `compare_and_fill` does not guarantee to fill out all cells. At some point during the iteration, we may get stuck.

This is where we introduce back our exhaustive search approach. Should we, at some point during the execution of @fill-loop, get stuck (i.e. no value has been altered during one iteration), we assign one cell of value `UNASSIGNED` by force, and then continue the loop. @search shows the relevant code: if, at some point during the execution of @fill-loop, the matrix does not change, and there are still `UNASSIGNED` cells left, we assign both values, `EMPTY` and `FULL`, to this cell sequentially. Notice line 10 of @search: As soon as we have to rely on exhaustive search, we are not guaranteed that a valid solution is unique. Thus, we have to
1. Search among all possible assignments of `UNASSIGNED` variables, and
2. Keep track how many solutions have been found.
We do not accept multiple solutions, which is why we immediately exit the program as soon as two solutions have been found.


#figure(
  placement: auto,
  caption: [Applying `compare_and_fill`],
  //placement: top,
  ```Python
  while(not is_done()):
    diag_lr = get_diagonal_lr(matrix)
    diag_rl = get_diagonal_rl(matrix)

    for i in range(height):
      compare_and_fill(in_horiz[i], matrix[i,:])
    for i in range(height + width - 1):
      compare_and_fill(in_diag_lr[i], diag_lr[i])
    for i in range(width):
      compare_and_fill(in_vert[i], matrix[:,i])
    for i in range(height + width - 1):
      compare_and_fill(in_diag_rl[i], diag_rl[i])
  ```,
) <fill-loop>


#figure(
  placement:auto,
  caption: [Exhaustive Search],
  ```Python
  # ... inside fill_loop()
  if not has_change_occured:
    # indices of unassigned cells
    indices_of_unassigned = np.argwhere(matrix.cell == UNASSIGNED)

    for idx in indices_of_unassigned:
      for assignment in [EMPTY, FULL]:
        # assign value to matrix[idx]
        search_in_branch(idx, value, matrix)
        if solutions_found > 1:
          # the solution is ambiguous -> leave loop
          return
  ```,
) <search>


= Analysis <analysis>

We have seen in @iterate that we need to resort to exhaustive search algorithms for some inputs. Our naive approach has a worst-case time-complexity of $cal(O)(2^(m times n))$ for obvious reasons. To research the quality of our algorithm, we want to quantify the fraction of all inputs that can be solved in sub-exponential time, meaning, without having to resort to exhaustive search.

We approached this question experimentally. This chapter describes this experiments setup and presents and discusses its results.


== Setup <setup>

1. Modify `scanner.py` to terminate if it has not found a solution after $T_(max)$ seconds.
2. Generate $N=1000$ inputs that satisfy the chunk-property using the function `generate_chunk`, see @generate_chunk.
3. Apply `scanner.py` to each input and count the number of terminations.
4. Repeat step 2 and 3 with variating values for the parameter `chance` in `generate_chunk` to find the worst-case result.

For point 1, the exact value of $T_max$ depends on the machine that is being used. We have found a great number of inputs to be solvable in $~0.07s$. We thus chose $T_max = 0.1s$ as an appropriate threshold value.

To generate an input, we developed `generate_chunk(chance, height, width)`, see @generate_chunk. The function iterates over every cell and turns it to a `FULL` cell with a probability of `chance`. This is repeated `min(height, width)` times. The value of `chance` is variable, as we repeat the experiment for various values of $"chance" in [0.15, 0.16, ..., 0.25]$ to find the worst-case result. We furthermore chose `height = 10` and `width = 15`, as those are the values used in the original problem description.



#figure(
  placement: auto,
  caption: [Generating chunk data],
  ```Python
def generate_chunk(chance, height, width):
  chunk_matrix = all_empty(height, width)

  # make middle element 1
  chunk_matrix[int(height/2), int(width/2)] = 1

  for _ in range(min(height, width)):
    for cell in chunk_matrix:
      if one_neighbor_of(cell) == FULL and random.random() < chance
        cell = FULL
      
  matrix_to_data(chunk_matrix, height, width)
  ```
) <generate_chunk>



== Results <results>

#figure(
  placement: auto,
  caption: [Results of the experiment],
  table(
    columns: 4,
    align: (center, center,),
    inset: 5pt,
    stroke: none,
    gutter: 0.5em,

    // Top rule
  table.hline(stroke: 1.25pt),

    [`chance` in %],[timeout-rate in %],
    [`chance` in %],[timeout-rate in %],
    
    // Mid rule
    table.hline(stroke: 0.75pt),

    [0.10],[0.2],
    table.vline(),
    [0.21],[1.0],
    [0.11],[0.2],
    [0.22],[1.4],
    [0.12],[0.0],
    [0.23],[0.9],
    [0.13],[0.3],
    [0.24],[1.1],
    [0.14],[0.7],
    [0.25],[0.5],
    [0.15],[1.0],
    [0.26],[0.4],
    [0.16],[0.9],
    [0.27],[0.7],
    [0.17],[1.2],
    [0.28],[0.1],
    [0.18],[0.8],
    [0.29],[0.2],
    [0.19],[1.1],
    [0.30],[0.1],
    [0.20],[1.2],


  // Bottom rule
  table.hline(stroke: 1.25pt),
  )
) <exp-result-table>

#figure(
  placement: auto,
  caption: [Scatterplot of the results],
  image("plot.svg")
) <exp-result-plot>



== Interpretation <interpretation>

Our experiment shows that the timeout-rate $t$ does not exceed $t = 1.5 %$. From this we can conclude that $~98.5 %$ of inputs can be solved in sub-exponential time.


= Future work <future>

The search algorithm we used is a simple exhaustive search. We put all work into reducing the search space such that exhaustive search has to be used as few times as possible. To further improve the performance for every possible input, future work may focus on finding better search algorithms. One possibility that has been tried during our research is simulated annealing. However, a thorough implementation was beyond the scope of this research project.