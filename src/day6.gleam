import gleam/list
import gleam/set
import gleam/string

pub fn solve(input) {
  let map = parse(input)
  let distinct_points = update_until_oob(map, set.new())
  set.size(distinct_points) - 1
}

pub fn parse(input) {
  let row = input |> string.split("\r\n")
  let height = row |> list.length()
  use map, row, row_index <- list.index_fold(row, new())
  let width = row |> string.length()
  let row_chars = string.to_graphemes(row)
  use map, char, col_index <- list.index_fold(row_chars, map)

  case char {
    "#" -> insert_obstruction(map, Point(col_index, row_index))
    "^" -> insert_guard(map, Guard(Point(col_index, row_index), Up))
    ">" -> insert_guard(map, Guard(Point(col_index, row_index), Right))
    "v" -> insert_guard(map, Guard(Point(col_index, row_index), Down))
    "<" -> insert_guard(map, Guard(Point(col_index, row_index), Left))
    _ -> Map(..map, width: width, height: height)
  }
}

pub type Direction {
  Up
  Right
  Down
  Left
}

pub type Guard {
  Guard(position: Point, direction: Direction)
}

pub type Point {
  Point(x: Int, y: Int)
}

pub type Map {
  Map(guard: Guard, obstructions: set.Set(Point), width: Int, height: Int)
}

pub fn new() {
  Map(Guard(Point(-1, -1), Up), set.new(), 0, 0)
}

pub fn insert_obstruction(map, point) {
  Map(..map, obstructions: map.obstructions |> set.insert(point))
}

pub fn insert_guard(map, guard) {
  Map(..map, guard: guard)
}

pub fn update_guard(map: Map) {
  let Point(x, y) = map.guard.position

  let next_position = case map.guard.direction {
    Up -> Point(x, y - 1)
    Right -> Point(x + 1, y)
    Down -> Point(x, y + 1)
    Left -> Point(x - 1, y)
  }

  let is_obstructed = set.contains(map.obstructions, next_position)

  case is_obstructed {
    True ->
      Map(
        ..map,
        guard: Guard(..map.guard, direction: rotate(map.guard.direction)),
      )
    False -> Map(..map, guard: Guard(..map.guard, position: next_position))
  }
}

pub fn update_until_oob(map: Map, visited: set.Set(Point)) {
  let map = update_guard(map)

  let guard_pos = map.guard.position
  let is_guard_oob =
    guard_pos.x < 0
    || guard_pos.x > map.width
    || guard_pos.y < 0
    || guard_pos.y > map.height

  case is_guard_oob {
    True -> visited
    False -> update_until_oob(map, set.insert(visited, guard_pos))
  }
}

pub fn rotate(direction) {
  case direction {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}
