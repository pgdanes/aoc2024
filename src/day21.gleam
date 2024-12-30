import char
import gleam/dict
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type KeyLocations =
  dict.Dict(String, #(Int, Int))

pub fn solve(in) {
  in
  |> string.trim()
  |> string.split("\n")
  |> list.map(get_code_complexity(_, 2))
  |> list.filter_map(function.identity)
  |> int.sum
}

pub fn build_movement_map(keypad: KeyLocations) {
  {
    let keys = dict.keys(keypad)
    use a <- list.flat_map(keys)
    use b <- list.filter_map(keys)

    let pair = #(a, b)
    use movement <- result.try(get_movement_to_key(keypad, pair.0, pair.1))
    Ok(#(#(pair.0, pair.1), movement))
  }
  |> dict.from_list
}

pub fn get_code_complexity(seq, robot_count: Int) {
  let shortest_sequence = get_chained_sequence(seq, robot_count)
  use nums <- result.try(
    seq
    |> string.to_graphemes
    |> list.filter(char.is_num)
    |> list.filter_map(int.parse)
    |> int.undigits(10),
  )

  Ok(string.length(shortest_sequence) * nums)
}

pub fn get_chained_sequence(seq, robot_count: Int) {
  let big_key_locs = build_big_keypad()
  let big_movement_map = build_movement_map(big_key_locs)

  let small_key_locs = build_small_keypad()
  let small_movement_map = build_movement_map(small_key_locs)

  let big_key_seq =
    seq
    |> get_movement_string(big_movement_map, start: "A")

  list.range(0, robot_count - 1)
  |> list.fold(big_key_seq, fn(last_seq, _n) {
    get_movement_string(last_seq, small_movement_map, start: "A")
  })
}

fn get_movement_string(
  input_seq: String,
  movement_map: dict.Dict(#(String, String), String),
  start starting_key: String,
) {
  string.to_graphemes(input_seq)
  |> list.prepend(starting_key)
  |> list.window_by_2()
  |> list.filter_map(fn(movement) {
    dict.get(movement_map, #(movement.0, movement.1))
  })
  |> string.join("")
}

pub fn get_movement_to_key(
  key_locations: KeyLocations,
  current_key: String,
  target_key: String,
) {
  use current_location <- result.try(dict.get(key_locations, current_key))
  use target_location <- result.try(dict.get(key_locations, target_key))

  let delta = #(
    target_location.0 - current_location.0,
    target_location.1 - current_location.1,
  )

  let x_move_char = {
    case delta.0 {
      x if x > 0 -> ">"
      x if x < 0 -> "<"
      _ -> ""
    }
  }
  let y_move_char = {
    case delta.1 {
      y if y > 0 -> "^"
      y if y < 0 -> "v"
      _ -> ""
    }
  }
  let x_moves_chars = string.repeat(x_move_char, int.absolute_value(delta.0))
  let y_moves_chars = string.repeat(y_move_char, int.absolute_value(delta.1))
  let move_chars = { x_moves_chars <> y_moves_chars } |> sort_moves()

  case is_valid_move_sequence(key_locations, current_key, move_chars) {
    True -> Ok(move_chars <> "A")
    False -> Ok({ move_chars |> string.reverse() } <> "A")
  }
}

/// sorting the moves is important because some moves are closer to the "A" button
/// by doing the more expensive ones first you reduce the amount of moves in the next
/// robots commands
///
/// e.g. the command ">^A" is more expensive than "^>A" because right is only one step
/// away from A, but up is two.
pub fn sort_moves(moves: String) {
  moves
  |> string.to_graphemes()
  |> list.map(fn(c) {
    case c {
      "<" -> #(c, 0)
      "^" -> #(c, 1)
      "v" -> #(c, 2)
      ">" -> #(c, 3)
      _ -> panic as "invalid direction"
    }
  })
  |> list.sort(fn(a, b) { int.compare(a.1, b.1) })
  |> list.map(fn(c) { c.0 })
  |> string.join("")
}

/// checks if any move within the sequence will pass over an empty spot
pub fn is_valid_move_sequence(
  key_locs: KeyLocations,
  current_key: String,
  move_string: String,
) {
  let moves =
    move_string
    |> string.to_graphemes()
    |> list.map(fn(c) {
      case c {
        "<" -> #(-1, 0)
        "^" -> #(0, 1)
        "v" -> #(0, -1)
        ">" -> #(1, 0)
        _ -> panic as "not valid direction"
      }
    })

  {
    use current_loc <- result.try(dict.get(key_locs, current_key))

    let result =
      list.fold(moves, #(current_loc, [current_loc]), fn(acc, offset) {
        let next_loc = #(acc.0.0 + offset.0, acc.0.1 + offset.1)
        #(next_loc, [next_loc, ..acc.1])
      })

    let #(_, visited) = result
    let key_locations = dict.values(key_locs)

    let contains =
      visited
      |> list.all(fn(loc) { list.contains(key_locations, loc) })

    Ok(contains)
  }
  |> result.unwrap(False)
}

/// +---+---+---+
/// | 7 | 8 | 9 |
/// +---+---+---+
/// | 4 | 5 | 6 |
/// +---+---+---+
/// | 1 | 2 | 3 |
/// +---+---+---+
///     | 0 | A |
///     +---+---+
pub fn build_big_keypad() {
  dict.from_list([
    #("7", #(0, 3)),
    #("8", #(1, 3)),
    #("9", #(2, 3)),
    #("4", #(0, 2)),
    #("5", #(1, 2)),
    #("6", #(2, 2)),
    #("1", #(0, 1)),
    #("2", #(1, 1)),
    #("3", #(2, 1)),
    #("0", #(1, 0)),
    #("A", #(2, 0)),
  ])
}

///     +---+---+
///     | ^ | A |
/// +---+---+---+
/// | < | v | > |
/// +---+---+---+
pub fn build_small_keypad() {
  dict.from_list([
    #("<", #(0, 0)),
    #("v", #(1, 0)),
    #(">", #(2, 0)),
    #("^", #(1, 1)),
    #("A", #(2, 1)),
  ])
}
