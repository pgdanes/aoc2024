import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set
import gleam/string

pub fn solve(input: String) {
  let page = parse(input)

  page.updates
  |> list.filter(fn(update) { is_valid_update(update, page.rules) })
  |> list.filter_map(get_middle_number)
  |> int.sum
}

pub fn is_valid_update(update: Update, rules: OrderingRules) {
  let reversed = update |> list.reverse()
  let first = update |> list.take(list.length(update) - 1)

  case reversed {
    [last, ..rest] -> {
      let afters =
        dict.get(rules, last)
        |> result.unwrap([])

      let valid = set.is_disjoint(set.from_list(rest), set.from_list(afters))

      case valid {
        False -> False
        True -> is_valid_update(first, rules)
      }
    }
    [] -> True
  }
}

pub fn get_middle_number(update: Update) {
  let len = list.length(update)
  update |> list.take({ len / 2 } + 1) |> list.last
}

pub fn parse(input: String) {
  let assert [rules, updates] = input |> string.split("\n\n")
  Page(parse_rules(rules), parse_updates(updates))
}

pub fn parse_rules(input: String) {
  let rules = string.split(input, "\n")
  use ordering_rules, row <- list.fold(rules, dict.new())

  let chars = string.split(row, "|")
  let pair = list.map(chars, int.parse)
  let assert [Ok(before), Ok(after)] = pair

  dict.upsert(ordering_rules, before, fn(value) {
    case value {
      Some(list) -> [after, ..list]
      None -> [after]
    }
  })
}

pub fn parse_updates(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, ","))
  |> list.map(list.filter_map(_, int.parse))
}

pub type Page {
  Page(rules: OrderingRules, updates: List(Update))
}

pub type Update =
  List(Int)

pub type OrderingRules =
  dict.Dict(Int, List(Int))
