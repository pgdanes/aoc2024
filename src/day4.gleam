import gleam/dict
import gleam/int
import gleam/io
import gleam/list
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
        // io.debug(#(
        //   offset(cell_origin, cs.0.0, cs.0.1),
        //   offset(cell_origin, cs.1.0, cs.1.1),
        //   offset(cell_origin, cs.2.0, cs.2.1),
        //   offset(cell_origin, cs.3.0, cs.3.1),
        // ))
        // io.debug(#(get(cs.0), get(cs.1), get(cs.2), get(cs.3)))
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
  |> list.map(fn(x) {
    case x {
      True -> 1
      False -> 0
    }
  })
  |> int.sum
}

pub fn offset(point: Coord, x, y: Int) {
  #(point.0 + x, point.1 + y)
}
