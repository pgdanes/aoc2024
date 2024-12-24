import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn solve(input: String) {
  parse(input) |> blink_n(25) |> list.length
}

pub fn parse(in) {
  in |> string.trim() |> string.split(" ") |> list.filter_map(int.parse)
}

pub fn blink(nums) {
  nums |> list.filter_map(apply_stone_rule) |> list.flatten
}

pub fn blink_n(nums, n) {
  case n {
    0 -> nums
    n -> blink_n(blink(nums), n - 1)
  }
}

pub fn apply_stone_rule(num) {
  case num, even_digits(num) {
    0, _ -> Ok([1])
    n, True -> {
      split_stone(n)
    }
    n, _ -> Ok([n * 2024])
  }
}

pub fn split_stone(num) {
  use nums <- result.try(int.digits(num, 10))
  let half = list.length(nums) / 2
  let chunks = list.sized_chunk(nums, half)
  let joined = chunks |> list.filter_map(int.undigits(_, 10))

  Ok(joined)
}

pub fn even_digits(num) {
  int.digits(num, 10)
  |> result.unwrap([])
  |> list.length
  |> fn(x) { x % 2 == 0 }
}
