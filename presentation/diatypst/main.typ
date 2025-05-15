#import "@preview/diatypst:0.5.0": *

#show: slides.with(
  title: "Scanner", // Required
  subtitle: "Proseminar SS25",
  date: "01.07.2024",
  authors: "David Knöpp",

  // Optional Styling (for more / explanation see in the typst universe)
  ratio: 16 / 9,
  layout: "medium",
  title-color: green,
  toc: true,
  count: "number",
  footer: false,
)

#let dual_matrix(image_link, code) = {
  grid(
    align: center + horizon,
    //rows: (50%, 50%),
    columns: (50%, 50%),
    [#image(image_link, height: 80%)],
    code,
  )
}

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
  [```
      .##.
      .##.
      ###.
      ##..
    ```
    This is our actual output],
)

#align(center, "But what is our input?")

== Getting the input

#dual_matrix(
  "matrix-Matrix Horiz Numbers.drawio.svg",
  [```
    2 2 3 2



    ```],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix DiagLR Numbers.drawio.svg",
  [```
    2 2 3 2
    0 1 3 3 2 0 0


    ```],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix Vert Numbers.drawio.svg",
  [```
    2 2 3 2
    0 1 3 3 2 0 0
    2 4 3 0

    ```],
)

== Getting the input

#dual_matrix(
  "matrix-Matrix DiagRL Numbers.drawio.svg",
  [```
    2 2 3 2
    0 1 3 3 2 0 0
    2 4 3 0
    1 2 1 2 2 1 0
    ```],
)

== Getting the input

#grid(
    align: center + horizon,
    rows: (20%, 70%, 10%),
    [The number at the top represents the number of matrices that will follow.
    
    In our case, it's just one.],
    [```
    1
    2 2 3 2
    0 1 3 3 2 0 0
    2 4 3 0
    1 2 1 2 2 1 0
    ```],
    [And that's our input! ]
  )

== Live Demo

insert picture


= Solution

== Tools

- Python
- Numpy

== Algorithm

yay

