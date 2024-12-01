import gleam/int
import gleam/list
import gleam/string

pub fn solve(input: String) {
  let lists = parse(input)

  let sorted = lists
    |> list.map(list.sort(_, by: int.compare))

  let diff = case sorted {
    [[_, ..] as first, [_, ..] as second] -> {
      Ok(list.map2(first, second, fn(x, y) { int.absolute_value(y - x) }))
    }
    _ -> Error("more than two lists given")
  }

  case diff {
    Ok(list) -> int.sum(list)
    _ -> 0 
  }
}

pub fn parse(input: String) {
  input 
    |> string.split("\n")
    |> list.filter_map(parse_pair)
    |> list.transpose()
}

pub fn parse_pair(input: String) {
  let pair = 
    input 
    |> string.split("   ")
    |> list.map(int.base_parse(_, 10))

  case pair {
    [Ok(x), Ok(y)] -> Ok([x, y])
    _ -> Error("invalid pair")
  }
}
