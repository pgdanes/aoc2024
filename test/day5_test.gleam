import day5
import gleam/io
import gleeunit/should
import simplifile

pub fn day5_solve_test() {
  "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"
  |> day5.solve
  |> should.equal(143)
}

pub fn day5_solve_b_test() {
  "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"
  |> day5.solve_b
  |> should.equal(123)
}

pub fn middle_test() {
  [1, 2, 3, 4, 5] |> day5.get_middle_number() |> should.equal(Ok(3))
}

pub fn day5_real_test() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day5")

  in
  |> day5.solve()
  |> should.equal(7307)

  in
  |> day5.solve_b()
  |> should.equal(4713)
}
