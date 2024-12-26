import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import parse
import vec

pub fn solve_a(input) {
  solve(input, get_antinodes)
}

pub fn solve_b(input) {
  solve(input, get_antinodes_b)
}

pub fn solve(input, antinode_fn) {
  let bounds = parse.dimensions(input)
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
  |> list.unique
  |> list.length
}

pub fn parse(input) {
  use map, x, y, char <- parse.make_map(input)

  case char {
    "." -> map
    _ -> {
      use existing <- dict.upsert(map, char)
      case existing {
        Some(points) -> [#(x, y), ..points]
        None -> [#(x, y)]
      }
    }
  }
}

pub fn get_antinodes(a, b, bounds) {
  let offset = vec.distance(a, b)
  let reverse_offset = vec.reverse(offset)

  [vec.add(a, reverse_offset), vec.add(b, offset)]
  |> list.filter(vec.is_in_bounds(_, bounds))
}

pub fn get_antinodes_b(a, b, bounds) {
  let offset = vec.distance(a, b)
  let reverse_offset = vec.reverse(offset)

  [
    get_antinodes_rec(a, reverse_offset, bounds, [a]),
    get_antinodes_rec(b, offset, bounds, [b]),
  ]
  |> list.flatten
}

pub fn get_antinodes_rec(a, offset, bounds, acc) {
  let new_point = vec.add(a, offset)

  case vec.is_in_bounds(new_point, bounds) {
    True -> get_antinodes_rec(new_point, offset, bounds, [new_point, ..acc])
    False -> acc
  }
}
