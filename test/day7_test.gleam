import gleeunit/should
import simplifile
import day7

pub fn day7_solve_test() {
  "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
  |> day7.solve
  |> should.equal(11387)
}

pub fn day7_solve_real_test() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day7")

  in
  |> day7.solve
  |> should.equal(227921760109726)
}
