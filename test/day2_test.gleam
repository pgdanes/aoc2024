import day2
import gleam/io
import gleeunit/should

pub fn day2_a_test() {
  let in =
    "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

  in |> day2.solve |> should.equal(2)
}

pub fn day2_a_dir_test() {
  [9, 7, 6, 3, 1] |> day2.is_consistent_direction |> should.be_true()
  [1, 3, 6, 7, 9] |> day2.is_consistent_direction |> should.be_true()
}

pub fn day2_a_dir_fail_test() {
  [1, 3, 2, 7, 9] |> day2.is_consistent_direction |> should.be_false()
}

pub fn day2_parse_test() {
  let in = "7 6 4 2 1"

  in |> day2.parse |> should.equal([[7, 6, 4, 2, 1]])
}
