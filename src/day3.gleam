import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn solve(input: String) {
  parse(input)
  |> list.map(fn(pair) {
    let #(x, y) = pair
    x * y
  })
  |> int.sum
}

pub fn parse(input: String) {
  parse_rec(input, [])
  |> list.reverse()
  |> list.map(fn(pair) {
    let #(x, y) = pair
    let assert #(Ok(x_num), Ok(y_num)) = #(int.parse(x), int.parse(y))
    #(x_num, y_num)
  })
}

fn parse_rec(input: String, acc: List(#(String, String))) {
  case input {
    "" -> acc
    "mul" <> rest -> {
      let mul = parse_mul(rest)
      case mul {
        Some(x) -> parse_rec(rest, [x, ..acc])
        None -> parse_rec(string.drop_start(input, 1), acc)
      }
    }
    _ -> parse_rec(string.drop_start(input, 1), acc)
  }
}

pub fn parse_mul(expr: String) {
  let #(lparen, rest) = take_while(expr, fn(c) { c == "(" }, "")
  let #(x, rest) = take_while(rest, is_num, "")
  let #(_, rest) = take_while(rest, fn(c) { c == "," }, "")
  let #(y, rest) = take_while(rest, is_num, "")
  let #(rparen, _) = take_while(rest, fn(c) { c == ")" }, "")

  case lparen, rparen {
    "", _ -> None
    _, "" -> None
    _, _ -> Some(#(x, y))
  }
}

fn take_while(
  input: String,
  pred: fn(String) -> Bool,
  acc: String,
) -> #(String, String) {
  let g = string.pop_grapheme(input)

  case g {
    Error(_) -> #(acc, input)
    Ok(#(n, next)) -> {
      case pred(n) {
        True -> take_while(next, pred, acc <> n)
        False -> #(acc, n <> next)
      }
    }
  }
}

fn is_num(c: String) {
  case c {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}
