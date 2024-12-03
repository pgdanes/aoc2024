import simplifile
import day3
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleeunit/should

pub fn day3_solve_test() {
  let in =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  in
  |> day3.solve
  |> should.equal(161)
}

pub fn day3_real_test() {
  let assert Ok(input) = simplifile.read(from: "test/inputs/day3")
  input |> day3.solve() |> io.debug()
}

pub fn day3_parse_test() {
  let in =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  in
  |> day3.parse
  |> list.reverse()
  |> should.equal([#(2, 4), #(5, 5), #(11, 8), #(8, 5)])
}

pub fn day3_parse_mul_test() {
  "(1,2)" |> day3.parse_mul() |> should.equal(Some(#("1", "2")))
  "(10,20)" |> day3.parse_mul() |> should.equal(Some(#("10", "20")))
  "(1,2]" |> day3.parse_mul() |> should.equal(None)
  "[1,2]" |> day3.parse_mul() |> should.equal(None)
}
