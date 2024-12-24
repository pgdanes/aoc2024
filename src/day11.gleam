import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string

pub fn solve(input: String) {
  parse(input)
  |> initial_counts
  |> blink_n(75)
  |> dict.values()
  |> int.sum()
}

pub fn parse(in) {
  in |> string.trim() |> string.split(" ") |> list.filter_map(int.parse)
}

fn split_stones(nums) {
  use num <- list.flat_map(nums)

  case num, even_digits(num) {
    0, _ -> [1]
    n, True -> split_stone(n)
    n, _ -> [n * 2024]
  }
}

fn blink_n(nums: dict.Dict(Int, Int), n) {
  case n {
    0 -> nums
    n -> {
      let new_nums =
        dict.to_list(nums)
        |> split_with_previous_count
        |> count_stones

      blink_n(new_nums, n - 1)
    }
  }
}

fn split_with_previous_count(items: List(#(Int, Int))) {
  items
  |> list.flat_map(fn(item) {
    let #(stone, amount) = item
    use new_stone <- list.map(split_stones([stone]))
    #(new_stone, amount)
  })
}

fn initial_counts(nums: List(Int))
{
  list.fold(nums, dict.new(), fn(acc, curr) {
    dict.upsert(acc, curr, fn(result) {
      case result {
        Some(r) -> r + 1
        _ -> 1
      }
    })
  })
}
fn count_stones(nums: List(#(Int, Int))) {
  use d, item <- list.fold(nums, dict.new())
  let #(label, size) = item
  use result <- dict.upsert(d, label)

  case result {
    Some(count) -> count + size
    _ -> size
  }
}

pub fn split_stone(num) {
  let assert Ok(nums) = int.digits(num, 10)
  let half = list.length(nums) / 2
  let chunks = list.sized_chunk(nums, half)
  chunks |> list.filter_map(int.undigits(_, 10))
}

pub fn even_digits(num) {
  int.digits(num, 10)
  |> result.unwrap([])
  |> list.length
  |> fn(x) { x % 2 == 0 }
}
