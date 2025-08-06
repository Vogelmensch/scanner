#import "template.typ": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, edge, node

#show: acmart.with(
  format: "acmsmall",
  // Text in "" is taken literally, while text in [] is "interpreted", e.g., --- is converted to an m-dash
  title: [Scanner-Paper],
  subtitle: "A subtitle is purely optional",
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
    Start with a structured abstract as a tiny text. That should *not* become your final version of an abstract without alteration.

    An abstract (for a short paper like yours) should comprise about 100-150~words. Please, write a minimum of 80 and a maximum of 200~words.
  ],
  ccs: none,
  keywords: ("Keywords", "To", "Increase", "Discoverability"),
  copyright: "studentpaper",

  acmYear: 2025,
)

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


= Encoding a 3d body

To understand the scanner-algorithm, we must first understand the semantics of the code we are solving. In this section, we start with a three-dimensional body and encode it step by step, to end up with a set of integer-arrays.

Step one: Along the vertical axis, the body is divided into a finite set of two-dimensional slices. Each slice is viewed as constant in depth along the vertical axis. We then encode every slice independently of the others. All subsequent steps are applied to each slice individually. For the rest of the paper, we focus on one slice only for understandability.

Step two: The slice is discretized as a grid of $h times w$ cells. A cell's state is binary-encoded: if the cell contains any portion of the body, the cell is encoded as `FULL`. Otherwise, it is encoded as `EMPTY`.

Step three: The grid of cells is now being measured for its depth along four directions:
- horizontal
- first diagonal (from bottom left to top right)
- vertical, and
- second diagonal (from bottom right to top left).
For each of those directions, the discretized body's depth is measured at all possible locations. For a grid of dimension $h times w$, this yields four arrays with $h$, $h + w + 1$, $w$, and $h + w + 1$ entries respectively.

Those four arrays make up the encoded slice.


= Reconstructing a slice

We are given two integer-arrays of lengths $m$ and $n$, and two integer-arrays of lengths $m + n + 1$, all representing the depth of the object in the four possible directions. We want to reconstruct the discretized image from this data only. In this chapter, we explain the algorithmic approach we found to be most effective.

\<say what is being done in this chapter lol. Like that we build the solution bottom up.
- Introduce terminology: Matrix, Cells-Values `FULL`, `EMPTY` and `UNASSIGNED`
- Dimensionality of the matrix from the input length
\>

== Naive Local Search

The dimension of the resulting matrix is known from the lengths of the horizontal and vertical input arrays. The possible values to fill the matrix with are also known (0 and 1). Thus, we can simply try out all possible solutions, calculate the depth of the resulting object at the four given directions, and compare those to the input arrays.

This approach is obviously not optimal, as it has exponential time complexity. However, we will need to incorporate local search into our solution to guarantee completeness, as we will see later.


== Exploiting the chunk property

Our goal is to reduce the search space of local search such that the slice can be reconstructed in sub-exponential time. To achieve this goal, we exploit a property our resulting matrices have. We call this the chunk property.

We know that we are recreating images of two-dimensional bodies. The term "body" is interpreted as: Most of the `FULL`-valued cells of the matrix are located next to each. What we do not expect, for example, is a noisy image, where the value of a cell is decided randomly.

From the chunk property follows that some sub-arrays (verticals, horizontals or diagonals) of the matrix may be completely filled with `EMPTY`-values. The respective depth for this sub-array must then be zero. Searching for zeros in the input thus leads to complete knowledge of all values in the respective sub-array.

On the other hand, from the chunk property follows that some sub-arrays may be completely filled with `FULL`-values. The respective depth for this sub-array must then be equal to the length of the sub-array. Searching for values of maximal depth in the input thus leads to complete knowledge of all values in the respective sub-array as well.

@compare-and-fill shows the code implementing `compare_and_fill`, the function which fills all cells whose state we can derive logically by the chunk property. Its parameters are 
- `sensor_data_point`, a single depth-value from the input
- `arr`, the corresponding sub-array of the matrix.
The function does exactly what has been described above: if `sensor_data_point` equals zero, it assigns all unassigned values of `arr` to `EMPTY`. If `sensor_data_point` equals the number of unassigned values of `arr`, it assigns all those values to `FULL`.

TODO: update_sensor_data 


#figure(
  caption: [Using the chunk property],
  placement: top,
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
                  update_sensor_data(cell.x, cell.y)

  ```
) <compare-and-fill>


== Termination conditions

\<The conditions that can be met to find out that we are done\>

== Putting it together?

\<How all parts go together. And find a better title.\>


= Analysis


= Further stuff

- local search algorithms: maybe faster, but cannot find double solutions or no solution
