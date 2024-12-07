import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

pub fn solve(input) {
  let equations = parse(input)

  equations
  |> list.filter(fn(eq) { get_solving_combos(eq) |> list.length > 0 })
  |> list.map(fn(eq) { eq.output })
  |> int.sum
}

pub fn parse(input) {
  input
  |> string.trim_end()
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(output, operands)) = string.split_once(line, ":")

    let ops =
      operands
      |> string.trim_start()
      |> string.split(" ")
      |> list.map(int.parse)
      |> list.map(fn(x) { Num(result.unwrap(x, 0)) })

    Equation(output: int.parse(output) |> result.unwrap(0), operands: ops)
  })
}

pub fn get_solving_combos(equation: Equation) {
  let operator_combos = get_all_operator_combos(equation.operands)

  operator_combos
  |> list.map(fn(operators) { list.interleave([equation.operands, operators]) })
  |> list.map(eval)
  |> list.filter(fn(result) {
    case result {
      Ok(n) -> n == equation.output
      Error(_) -> False
    }
  })
}

pub fn eval(operation: List(Token)) {
  let tokens = operation |> list.take(3)
  let rest = operation |> list.drop(3)

  case tokens {
    [Num(x), Operator(Mul), Num(y)] -> eval([Num(x * y), ..rest])
    [Num(x), Operator(Add), Num(y)] -> eval([Num(x + y), ..rest])
    [Num(x), Operator(Combine), Num(y)] -> eval([Num(combine(x, y)), ..rest])
    [Num(total)] -> Ok(total)
    _ -> Error(Nil)
  }
}

pub fn combine(x: Int, y: Int) {
  let combined = int.to_string(x) <> int.to_string(y)
  int.parse(combined) |> result.unwrap(0)
}

pub fn get_all_operator_combos(operands: List(Token)) {
  let length = list.length(operands) - 1
  list.repeat(0, length)

  let all_cs =
    list.repeat([Operator(Mul), Operator(Add), Operator(Combine)], length)
    |> list.flatten
    |> list.combinations(length)
    |> list.fold(set.new(), fn(s, c) { set.insert(s, c) })

  all_cs |> set.to_list()
}

pub type OperatorType {
  Mul
  Add
  Combine
}

pub type Token {
  Operator(OperatorType)
  Num(Int)
}

pub type Equation {
  Equation(output: Int, operands: List(Token))
}
