import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn solve(input) {
  let point_dict = parse(input)
  let bounds = get_map_bounds(input)

  let all_antinodes =
    point_dict
    |> dict.keys()
    |> list.map(fn(key) {
      let assert Ok(points) = dict.get(point_dict, key)

      points
      |> list.combination_pairs()
      |> list.map(fn(node_pair) {
        let antinodes = get_antinodes(node_pair.0, node_pair.1)
        io.debug(#(key, node_pair, antinodes))
        antinodes
      })
    })
    |> list.flatten
    |> list.flatten

  let filtered =
    all_antinodes
    |> list.filter(fn(antinode) {
      antinode.0 >= 0
      && antinode.0 < bounds.0
      && antinode.1 >= 0
      && antinode.1 < bounds.1
    })
    |> list.unique

  filtered |> list.each(io.debug)

  filtered
  |> list.length
}

pub fn parse(input) {
  let rows = input |> string.trim_end() |> string.split("\n")
  use map, row, y <- list.index_fold(rows, dict.new())
  let cols = row |> string.to_graphemes()
  use map, char, x <- list.index_fold(cols, map)

  case char {
    "." -> map
    _ ->
      dict.upsert(map, char, fn(existing) {
        case existing {
          Some(points) -> [#(x, y), ..points]
          None -> [#(x, y)]
        }
      })
  }
}

pub fn get_map_bounds(input: String) {
  let rows = input |> string.trim_end() |> string.split("\n")
  let cols = rows |> list.first()
  let row_length = cols |> result.unwrap("") |> string.length()

  #(row_length, list.length(rows))
}

pub fn get_antinodes(p1: Point, p2: Point) {
  let offset = get_vec_between(p1, p2)
  let reverse_offset = reverse(offset)

  [add(p1, reverse_offset), add(p2, offset)]
}

pub fn get_vec_between(p1: Point, p2: Point) {
  #(p2.0 - p1.0, p2.1 - p1.1)
}

pub fn add(p1: Point, p2: Point) {
  #(p1.0 + p2.0, p1.1 + p2.1)
}

pub fn reverse(p: Point) {
  #(-p.0, -p.1)
}

pub type Point =
  #(Int, Int)
