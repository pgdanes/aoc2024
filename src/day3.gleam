import char
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn solve(input: String) {
  parse(input)
  |> list.map(fn(pair) {
    case pair {
      Multiple(#(x, y)) -> x * y
      _ -> 0
    }
  })
  |> int.sum
}

pub fn solve_b(input: String) {
  parse(input)
  |> list.reverse()
  |> list.fold(#(0, True), fn(acc, token) {
    case token {
      Condition(enable) -> {
        #(acc.0, enable)
      }
      Multiple(#(x, y)) -> {
        let #(total, enable) = acc
        case enable {
          True -> #(x * y + total, enable)
          False -> #(total, enable)
        }
      }
    }
  })
  |> fn(x) { x.0 }
}

pub type Token {
  Condition(Bool)
  Multiple(#(Int, Int))
}

pub fn parse(input: String) {
  parse_rec(input, [])
}

fn parse_rec(input: String, tokens: List(Token)) {
  case input {
    "" -> tokens
    "do()" <> rest -> parse_rec(rest, [Condition(True), ..tokens])
    "don't()" <> rest -> parse_rec(rest, [Condition(False), ..tokens])
    "mul" <> rest -> {
      case parse_mul(rest) {
        Some(multiple) -> parse_rec(rest, [multiple, ..tokens])
        None -> parse_rec(string.drop_start(input, 1), tokens)
      }
    }
    _ -> parse_rec(string.drop_start(input, 1), tokens)
  }
}

pub fn parse_mul(expr: String) {
  let #(lparen, rest) = expr |> take_while(char.is_left_paren)
  let #(x, rest) = rest |> take_while(char.is_num)
  let #(_, rest) = rest |> take_while(char.is_comma)
  let #(y, rest) = rest |> take_while(char.is_num)
  let #(rparen, _) = rest |> take_while(char.is_right_paren)

  case lparen, rparen {
    "", _ -> None
    _, "" -> None
    _, _ -> Some(#(x, y))
  }
  |> option.map(fn(pair) {
    let assert #(Ok(x_num), Ok(y_num)) = #(int.parse(pair.0), int.parse(pair.1))
    Multiple(#(x_num, y_num))
  })
}

fn take_while(input: String, pred: fn(String) -> Bool) {
  take_while_rec(input, pred, "")
}

fn take_while_rec(input: String, pred: fn(String) -> Bool, result_token: String) {
  case string.pop_grapheme(input) {
    Error(_) -> #(result_token, input)
    Ok(#(n, next)) -> {
      case pred(n) {
        True -> take_while_rec(next, pred, result_token <> n)
        False -> #(result_token, n <> next)
      }
    }
  }
}
