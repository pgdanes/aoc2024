import gleam/int
import gleam/list
import gleam/string

pub fn solve(input: String) {
  parse(input)
  |> list.map(is_safe)
  |> list.count(fn(x) { x == True })
}

pub fn solve_b(input: String) {
  parse(input)
  |> list.map(fn(report) {
    make_combinations(report)
    |> list.map(is_safe)
    |> list.any(fn(x) { x == True })
  })
  |> list.count(fn(x) { x == True })
}

pub fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.map(list.filter_map(_, int.base_parse(_, 10)))
}

fn make_combinations(report: List(Int)) -> List(List(Int)) {
  report |> list.combinations(list.length(report) - 1)
}

pub fn is_safe(report: List(Int)) -> Bool {
  is_safe_dist(report) && is_consistent_direction(report)
}

fn is_safe_dist(report: List(Int)) -> Bool {
  report
  |> list.window_by_2()
  |> list.fold(True, fn(result, x) {
    let #(x, y) = x
    result && is_safe_diff(x, y)
  })
}

fn is_safe_diff(x, y: Int) {
  case int.absolute_value(x - y) {
    x if x >= 1 && x <= 3 -> True
    _ -> False
  }
}

pub fn is_consistent_direction(input: List(Int)) {
  let dirs =
    input
    |> list.window_by_2()
    |> list.map(fn(x) {
      case x {
        #(a, b) -> a - b
      }
    })

  list.all(dirs, fn(x) { x > 0 }) || list.all(dirs, fn(x) { x < 0 })
}
