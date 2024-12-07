import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn solve(input) {
  let equations = parse(input)

  equations
  |> list.filter_map(try_solve(_, [Add, Mul, Combine]))
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
      |> list.map(fn(x) { result.unwrap(x, 0) })

    Equation(output: int.parse(output) |> result.unwrap(0), operands: ops)
  })
}

fn try_solve(equation, ops) {
  case equation {
    Equation(target, [final]) if final == target -> Ok(target)
    Equation(_, [a, b, ..rest]) -> {
      list.find_map(ops, fn(op) {
        let operands = [eval(op, a, b), ..rest]
        try_solve(Equation(..equation, operands: operands), ops)
      })
    }
    _ -> Error(Nil)
  }
}

pub fn eval(operator: Operator, x, y: Int) {
  case x, operator, y {
    x, Mul, y -> x * y
    x, Add, y -> x + y
    x, Combine, y -> combine(x, y)
  }
}

pub fn combine(x: Int, y: Int) {
  let assert Ok(y_dig) = int.digits(y, 10)
  let assert Ok(x_dig) = int.digits(x, 10)
  list.flatten([x_dig, y_dig]) |> int.undigits(10) |> result.unwrap(0)
}

pub type Operator {
  Mul
  Add
  Combine
}

pub type Equation {
  Equation(output: Int, operands: List(Int))
}
