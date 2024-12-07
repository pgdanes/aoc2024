import gleam/bool
import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/set
import gleam/string

pub fn solve(input) {
  let map = parse(input)
  let distinct_points = update_until_oob(map, set.new())
  set.size(distinct_points) - 1
}

pub fn solve_b(input) {
  let map = parse(input)
  let distinct_points = update_until_oob(map, set.new())

  distinct_points
  |> set.to_list()
  |> list.map(fn(p) { map.obstructions |> set.insert(p) })
  |> list.map(fn(new_set) {
    let tortoise_map = Map(..map, obstructions: new_set)
    let hare_map = Map(..map, obstructions: new_set)

    task.async(fn() { update_until_loop(tortoise_map, hare_map, #(0, 0)) })
  })
  |> task.try_await_all(2)
  |> list.map(result.unwrap(_, False))
  |> list.map(bool.to_int)
  |> int.sum
}

pub fn parse(input) {
  let row = input |> string.split("\n")
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

  case is_guard_oob(map) {
    True -> visited
    False -> update_until_oob(map, set.insert(visited, map.guard.position))
  }
}

pub fn update_until_loop(tortoise_map: Map, hare_map: Map, acc: #(Int, Int)) {
  let next_tortoise = update_guard(tortoise_map)
  let next_hare = update_guard(hare_map) |> update_guard()

  // io.debug(#(next_tortoise.guard.position, next_hare.guard.position))

  let is_guard_pos_same =
    next_tortoise.guard.position == next_hare.guard.position

  case is_guard_oob(next_hare), acc {
    True, _ -> False
    _, #(2, _) -> True
    _, #(meet_count, steps) ->
      update_until_loop(next_tortoise, next_hare, #(
        meet_count + bool.to_int(is_guard_pos_same),
        steps + 1,
      ))
  }
}

pub fn is_guard_oob(map: Map) {
  let guard_pos = map.guard.position
  guard_pos.x < 0
  || guard_pos.x > map.width
  || guard_pos.y < 0
  || guard_pos.y > map.height
}

pub fn rotate(direction) {
  case direction {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}
