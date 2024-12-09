import day9
import gleam/io
import simplifile

pub fn day9_sample_solve_test() {
  "2333133121414131402"
  |> day9.solve
  |> io.debug

  "12345"
  |> day9.solve
  |> io.debug
}

pub fn day9_solve_test() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day9")

  in
  |> day9.solve
  |> io.debug
}
