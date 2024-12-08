import gleam/dict
import gleam/list
import gleam/result
import gleam/string

pub fn lines(input) {
  input |> string.trim_end() |> string.split("\n")
}

pub fn dimensions(input) {
  let rows = lines(input)
  let cols = rows |> list.first()
  let row_length = cols |> result.unwrap("") |> string.length()
  #(row_length, list.length(rows))
}

pub fn make_map(
  input,
  f: fn(dict.Dict(a, b), Int, Int, String) -> dict.Dict(a, b),
) {
  let rows = lines(input)
  use map, row, y <- list.index_fold(rows, dict.new())
  let cols = row |> string.to_graphemes()
  use map, char, x <- list.index_fold(cols, map)

  f(map, x, y, char)
}
