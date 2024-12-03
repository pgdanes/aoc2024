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
  |> list.map(fn(pair) {
    let #(x, y) = pair
    let assert #(Ok(x_num), Ok(y_num)) = #(int.parse(x), int.parse(y))
    #(x_num, y_num)
  })
}

fn parse_rec(input: String, multiples: List(#(String, String))) {
  case input {
    "" -> multiples
    "mul" <> rest -> {
      case parse_mul(rest) {
        Some(x) -> parse_rec(rest, [x, ..multiples])
        None -> parse_rec(string.drop_start(input, 1), multiples)
      }
    }
    _ -> parse_rec(string.drop_start(input, 1), multiples)
  }
}

pub fn parse_mul(expr: String) {
  let #(lparen, rest) = expr |> take_while(is_left_paren)
  let #(x, rest) = rest |> take_while(is_num)
  let #(_, rest) = rest |> take_while(is_comma)
  let #(y, rest) = rest |> take_while(is_num)
  let #(rparen, _) = rest |> take_while(is_right_paren)

  case lparen, rparen {
    "", _ -> None
    _, "" -> None
    _, _ -> Some(#(x, y))
  }
}

fn take_while(input: String, pred: fn(String) -> Bool) {
  take_while_rec(input, pred, "")
}

fn take_while_rec(
  input: String,
  pred: fn(String) -> Bool,
  result_token: String,
) -> #(String, String) {
  let g = string.pop_grapheme(input)

  case g {
    Error(_) -> #(result_token, input)
    Ok(#(n, next)) -> {
      case pred(n) {
        True -> take_while_rec(next, pred, result_token <> n)
        False -> #(result_token, n <> next)
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

fn is_left_paren(c) {
  c == "("
}

fn is_comma(c) {
  c == ","
}

fn is_right_paren(c) {
  c == ")"
}
