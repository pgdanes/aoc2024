import simplifile
import day7.{Equation, Num, Operator, Mul, Add}
import gleam/io

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
  |> io.debug
}

// pub fn day7_solve_real_test() {
//   let assert Ok(in) = simplifile.read(from: "test/inputs/day7")
//
//   in
//   |> day7.solve
//   |> io.debug
//   // |> io.debug
// }

// pub fn day7_ops_test() {
//   [Num(10), Num(9), Num(8)] |> day7.get_all_operator_combos() |> io.debug
// }

// pub fn day7_get_solving_combos_test() {
//   Equation(3267, [Num(81), Num(40), Num(27)]) |> day7.get_solving_combos() |> io.debug
// }
//
// pub fn day7_eval_test() {
//   [Num(5), Operator(Mul), Num(2), Operator(Add), Num(2)] |> day7.eval() |> io.debug
// }
