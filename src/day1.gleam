import gleam/int
import gleam/list
import gleam/string

pub fn solve(input: String) {
  let assert Ok(#(left, right)) = parse(input)

  let left_sorted = list.sort(left, by: int.compare)
  let right_sorted = list.sort(right, by: int.compare)

  let diff =
    list.map2(left_sorted, right_sorted, fn(x, y) { int.absolute_value(y - x) })
  int.sum(diff)
}

pub fn parse(input: String) {
  let lists =
    input
    |> string.split("\n")
    |> list.filter_map(parse_pair)
    |> list.transpose()

  case lists {
    [[_, ..] as first, [_, ..] as second] -> Ok(#(first, second))
    _ -> Error("more than two lists parsed")
  }
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

pub fn solve_b(input: String) {
  let assert Ok(#(left, right)) = parse(input)

  left
  |> list.map(fn(x) { 
    x * list.count(right, fn(y) { x == y }) 
  })
  |> int.sum()
}
