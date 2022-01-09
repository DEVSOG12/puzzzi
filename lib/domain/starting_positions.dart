// ignore_for_file: constant_identifier_names

const STARTING_POSITIONS_3X3 = [
  [8, 6, 7, 2, 5, 4, 3, 0, 1],
  [6, 4, 7, 8, 5, 0, 3, 2, 1]
];

const STARTING_POSITIONS_4X4 = [
  // RALPH UDO GASSER
  // Harnessing Computational Resources for Efficient Exhaustive Search
  // http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.39.6069&rep=rep1&type=pdf
  [14, 15, 8, 12, 10, 11, 9, 13, 2, 6, 5, 1, 3, 7, 4, 0],
  [11, 15, 13, 12, 14, 10, 8, 9, 7, 2, 5, 1, 3, 6, 4, 0],
  [11, 15, 13, 12, 14, 10, 8, 9, 2, 6, 5, 1, 3, 7, 4, 0],
  [11, 15, 9, 12, 14, 10, 13, 8, 6, 7, 5, 1, 3, 2, 4, 0],
  [11, 15, 9, 12, 14, 10, 13, 8, 2, 6, 5, 1, 3, 7, 4, 0],
  [11, 15, 8, 12, 14, 10, 13, 9, 2, 7, 5, 1, 3, 6, 4, 0],
  [11, 15, 9, 12, 14, 10, 8, 13, 6, 2, 5, 1, 3, 7, 4, 0],
  [11, 15, 8, 12, 14, 10, 9, 13, 2, 6, 5, 1, 3, 7, 4, 0],
  [11, 15, 8, 12, 14, 10, 9, 13, 2, 6, 4, 5, 3, 7, 1, 0]
];

// @formatter:off
const STARTING_POSITIONS_5X5 = [
  // Few variants of 5x5 puzzle with a large manhattan
  // distance.
  [
    9,
    14,
    22,
    11,
    16,
    7,
    0,
    21,
    17,
    23,
    15,
    4,
    2,
    18,
    24,
    1,
    20,
    12,
    3,
    6,
    19,
    13,
    5,
    10,
    8
  ],
  [
    17,
    11,
    20,
    24,
    21,
    13,
    0,
    22,
    15,
    16,
    18,
    23,
    19,
    10,
    2,
    7,
    4,
    14,
    5,
    8,
    9,
    3,
    6,
    1,
    12
  ],
  [
    14,
    11,
    10,
    22,
    17,
    20,
    0,
    16,
    6,
    21,
    5,
    4,
    19,
    9,
    3,
    23,
    2,
    7,
    15,
    24,
    18,
    8,
    12,
    13,
    1
  ],
  [
    5,
    8,
    15,
    22,
    12,
    17,
    24,
    3,
    13,
    10,
    20,
    23,
    11,
    21,
    16,
    18,
    0,
    6,
    1,
    2,
    19,
    4,
    14,
    7,
    9
  ],
  [
    18,
    9,
    6,
    21,
    7,
    20,
    16,
    17,
    11,
    13,
    1,
    22,
    0,
    5,
    23,
    19,
    24,
    3,
    8,
    2,
    12,
    4,
    15,
    14,
    10
  ],
  [
    22,
    10,
    13,
    14,
    20,
    9,
    16,
    24,
    17,
    1,
    0,
    18,
    7,
    3,
    23,
    5,
    19,
    11,
    21,
    15,
    8,
    6,
    4,
    2,
    12
  ],
  [
    0,
    23,
    22,
    14,
    21,
    5,
    11,
    8,
    16,
    9,
    18,
    3,
    6,
    17,
    12,
    10,
    13,
    24,
    1,
    20,
    19,
    15,
    4,
    2,
    7
  ],
  [
    10,
    0,
    15,
    11,
    6,
    24,
    2,
    22,
    16,
    20,
    8,
    5,
    14,
    17,
    7,
    3,
    19,
    12,
    21,
    18,
    9,
    13,
    4,
    1,
    23
  ],
  [
    4,
    0,
    12,
    24,
    6,
    13,
    21,
    14,
    18,
    16,
    9,
    23,
    11,
    22,
    7,
    5,
    19,
    2,
    17,
    3,
    10,
    15,
    8,
    20,
    1
  ],
  [
    6,
    0,
    17,
    22,
    16,
    23,
    1,
    9,
    10,
    12,
    21,
    15,
    5,
    2,
    8,
    3,
    24,
    4,
    19,
    7,
    14,
    13,
    20,
    11,
    18
  ],
  [
    0,
    13,
    22,
    21,
    23,
    1,
    24,
    20,
    16,
    17,
    6,
    2,
    4,
    10,
    9,
    5,
    19,
    15,
    7,
    12,
    14,
    18,
    3,
    8,
    11
  ],
  [
    14,
    20,
    0,
    13,
    19,
    12,
    17,
    5,
    16,
    11,
    18,
    4,
    15,
    23,
    2,
    7,
    22,
    9,
    10,
    24,
    8,
    21,
    1,
    3,
    6
  ],
  [
    18,
    14,
    0,
    20,
    22,
    10,
    8,
    17,
    16,
    19,
    23,
    24,
    2,
    11,
    13,
    5,
    9,
    6,
    3,
    1,
    15,
    21,
    4,
    7,
    12
  ],
  [
    8,
    20,
    15,
    5,
    11,
    10,
    0,
    22,
    19,
    18,
    4,
    9,
    17,
    12,
    21,
    24,
    13,
    3,
    7,
    1,
    14,
    6,
    23,
    16,
    2
  ],
  [
    14,
    8,
    18,
    20,
    6,
    23,
    24,
    22,
    4,
    9,
    0,
    5,
    11,
    19,
    15,
    13,
    2,
    17,
    1,
    12,
    10,
    16,
    3,
    21,
    7
  ],
  [
    10,
    14,
    8,
    6,
    12,
    19,
    0,
    11,
    13,
    18,
    4,
    9,
    24,
    20,
    2,
    5,
    15,
    3,
    23,
    22,
    17,
    7,
    1,
    16,
    21
  ],
  [
    22,
    11,
    10,
    4,
    16,
    24,
    8,
    20,
    18,
    6,
    14,
    0,
    17,
    1,
    19,
    15,
    13,
    2,
    21,
    9,
    12,
    3,
    7,
    23,
    5
  ],
  [
    20,
    10,
    9,
    21,
    22,
    23,
    15,
    12,
    24,
    7,
    0,
    19,
    13,
    8,
    18,
    3,
    14,
    6,
    4,
    2,
    5,
    17,
    16,
    11,
    1
  ],
  [
    14,
    0,
    21,
    12,
    24,
    20,
    22,
    9,
    13,
    18,
    23,
    10,
    5,
    2,
    1,
    17,
    3,
    19,
    8,
    16,
    7,
    6,
    4,
    15,
    11
  ],
  [
    12,
    14,
    13,
    11,
    23,
    2,
    0,
    17,
    1,
    16,
    5,
    6,
    22,
    4,
    24,
    3,
    20,
    15,
    18,
    8,
    19,
    9,
    10,
    7,
    21
  ],
  [
    17,
    19,
    24,
    6,
    14,
    13,
    0,
    12,
    18,
    10,
    2,
    1,
    11,
    21,
    9,
    4,
    20,
    23,
    22,
    7,
    3,
    5,
    15,
    8,
    16
  ],
  [
    24,
    0,
    12,
    16,
    11,
    1,
    5,
    20,
    13,
    15,
    19,
    23,
    22,
    4,
    18,
    3,
    10,
    21,
    14,
    6,
    7,
    2,
    9,
    8,
    17
  ],
  [
    0,
    9,
    6,
    7,
    17,
    3,
    14,
    19,
    15,
    1,
    24,
    18,
    16,
    22,
    12,
    5,
    23,
    13,
    11,
    4,
    10,
    2,
    20,
    21,
    8
  ],
  [
    0,
    21,
    12,
    23,
    17,
    10,
    15,
    20,
    13,
    14,
    24,
    18,
    3,
    7,
    2,
    19,
    11,
    8,
    22,
    9,
    16,
    6,
    5,
    1,
    4
  ],
  [
    0,
    16,
    14,
    11,
    22,
    15,
    19,
    2,
    18,
    6,
    23,
    5,
    17,
    20,
    1,
    3,
    8,
    21,
    9,
    24,
    13,
    4,
    12,
    7,
    10
  ]
];
// @formatter:on
