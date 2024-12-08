import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn solve_a(input) {
  solve(input, get_antinodes)
}

pub fn solve_b(input) {
  solve(input, get_antinodes_b)
}

pub fn solve(input, antinode_fn: fn(Point, Point, #(Int, Int)) -> List(Point)) {
  let bounds = get_map_bounds(input)
  let point_dict = parse(input)

  point_dict
  |> dict.keys()
  |> list.map(fn(key) {
    let assert Ok(points) = dict.get(point_dict, key)

    points
    |> list.combination_pairs()
    |> list.map(fn(node_pair) { antinode_fn(node_pair.0, node_pair.1, bounds) })
  })
  |> list.flatten
  |> list.flatten
  |> list.filter(is_in_bounds(_, bounds))
  |> list.unique
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

pub fn get_antinodes(p1: Point, p2: Point, bounds: #(Int, Int)) {
  let offset = distance(p1, p2)
  let reverse_offset = reverse(offset)

  [add(p1, reverse_offset), add(p2, offset)]
  |> list.filter(is_in_bounds(_, bounds))
}

pub fn get_antinodes_b(p1: Point, p2: Point, bounds: #(Int, Int)) {
  let offset = distance(p1, p2)
  let reverse_offset = reverse(offset)

  [
    get_antinodes_rec(p1, reverse_offset, bounds, [p1]),
    get_antinodes_rec(p2, offset, bounds, [p2]),
  ]
  |> list.flatten
}

pub fn get_antinodes_rec(
  p1: Point,
  offset: Point,
  bounds: #(Int, Int),
  acc: List(Point),
) {
  let new_point = add(p1, offset)

  case is_in_bounds(new_point, bounds) {
    True -> get_antinodes_rec(new_point, offset, bounds, [new_point, ..acc])
    False -> acc
  }
}

pub fn distance(p1: Point, p2: Point) {
  #(p2.0 - p1.0, p2.1 - p1.1)
}

pub fn add(p1: Point, p2: Point) {
  #(p1.0 + p2.0, p1.1 + p2.1)
}

pub fn reverse(p: Point) {
  #(-p.0, -p.1)
}

pub fn is_in_bounds(antinode: Point, bounds: #(Int, Int)) {
  antinode.0 >= 0
  && antinode.0 < bounds.0
  && antinode.1 >= 0
  && antinode.1 < bounds.1
}

pub type Point =
  #(Int, Int)
