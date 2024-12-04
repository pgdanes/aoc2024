import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn solve(input: String) {
  let grid =
    input
    |> parse

  grid
  |> dict.keys
  |> list.map(fn(cell_point) { check_for_xmas(grid, cell_point) })
  |> int.sum
}

pub fn solve_b(input: String) {
  let grid =
    input
    |> parse

  grid
  |> dict.keys
  |> list.map(fn(cell_point) { check_for_cross_mas(grid, cell_point) })
  |> int.sum
}

pub fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(fn(line, y) {
    line
    |> list.index_map(fn(char, x) { #(#(x, y), char) })
  })
  |> list.flatten
  |> dict.from_list
}

pub type Coord =
  #(Int, Int)

pub type Grid =
  dict.Dict(Coord, String)

pub fn check_for_xmas(grid: Grid, cell_origin: Coord) {
  let get = fn(c: Coord) { grid |> dict.get(offset(cell_origin, c.0, c.1)) }

  let check_dir = fn(cs: #(Coord, Coord, Coord, Coord)) {
    case get(cs.0), get(cs.1), get(cs.2), get(cs.3) {
      Ok("X"), Ok("M"), Ok("A"), Ok("S") -> {
        True
      }
      _, _, _, _ -> False
    }
  }

  [
    // Horizontal
    check_dir(#(#(0, 0), #(1, 0), #(2, 0), #(3, 0))),
    check_dir(#(#(0, 0), #(-1, 0), #(-2, 0), #(-3, 0))),
    // Vertical
    check_dir(#(#(0, 0), #(0, 1), #(0, 2), #(0, 3))),
    check_dir(#(#(0, 0), #(0, -1), #(0, -2), #(0, -3))),
    // Diagonal
    check_dir(#(#(0, 0), #(1, 1), #(2, 2), #(3, 3))),
    check_dir(#(#(0, 0), #(1, -1), #(2, -2), #(3, -3))),
    check_dir(#(#(0, 0), #(-1, 1), #(-2, 2), #(-3, 3))),
    check_dir(#(#(0, 0), #(-1, -1), #(-2, -2), #(-3, -3))),
  ]
  |> list.map(bool.to_int)
  |> int.sum
}

pub fn check_for_cross_mas(grid: Grid, cell_origin: Coord) {
  let get = fn(c: Coord) { grid |> dict.get(offset(cell_origin, c.0, c.1)) }

  let check_dir = fn(cs: #(Coord, Coord, Coord)) {
    case get(cs.0), get(cs.1), get(cs.2) {
      Ok("M"), Ok("A"), Ok("S") -> {
        True
      }
      Ok("S"), Ok("A"), Ok("M") -> {
        True
      }
      _, _, _ -> False
    }
  }

  [
    check_dir(#(#(-1, -1), #(0, 0), #(1, 1)))
    && check_dir(#(#(-1, 1), #(0, 0), #(1, -1))),
  ]
  |> list.map(bool.to_int)
  |> int.sum
}

pub fn offset(point: Coord, x, y: Int) {
  #(point.0 + x, point.1 + y)
}
