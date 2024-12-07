import day6
import gleam/io
import simplifile

pub fn day6_solve_test() {
  "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
  |> day6.solve
  // |> io.debug
}

pub fn day6_real_solve_test() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day6")

  in
  |> day6.solve
  // |> io.debug
}

pub fn day6_solve_b_test() {
  "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
  |> day6.solve_b
  // |> io.debug
}

pub fn day6_solve_b_real_test() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day6")

  in
  |> day6.solve_b
  // |> io.debug
}
