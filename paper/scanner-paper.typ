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



// scanner-cell
#let scell(x, y, isFull, col: aqua) = node(
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
  stroke: (paint: red, thickness: 1pt),
)


#diagram(
  debug: true,
  spacing: (0pt, 0pt),

  // left annotations
  node((-1, 0), [2]),
  node((-1, 1), [2]),
  node((-1, 2), [3]),
  node((-1, 3), [2]),

  // bottom annotations
  node((0, 4), [2]),
  node((1, 4), [4]),
  node((2, 4), [3]),
  node((3, 4), [0]),

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

  // invisible nodes to enable coordinates for the edges
  node((4, 0), " "),
  node((0, -1), " "),

  // arrows
  sedge(0, 3, 3, 0),
)
