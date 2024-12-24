import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/regexp
import gleam/result
import gleam/string

pub fn solve(in) {
  parse(in)
  |> list.filter_map(fn(machine) {
    let assert [xa, ya, xb, yb, rx, ry] = machine
    let #(a_count, b_count) = get_counts(xa, ya, xb, yb, rx, ry)
    let valid = is_counts_valid(a_count, b_count, xa, ya, xb, yb, rx, ry)

    // io.debug(#(#(a_count, b_count), valid))
    case valid {
      True -> Ok(#(a_count, b_count))
      False -> Error(Nil)
    }
  })
  |> list.map(fn(counts) {
    let #(a_count, b_count) = counts
    3 * a_count + b_count
  })
  |> int.sum
}

pub fn solve_b(in) {
  parse(in)
  |> list.filter_map(fn(machine) {
    let assert [xa, ya, xb, yb, base_rx, base_ry] = machine
    let rx = base_rx + 10000000000000
    let ry = base_ry + 10000000000000

    let #(a_count, b_count) = get_counts(xa, ya, xb, yb, rx, ry)
    let valid = is_counts_valid(a_count, b_count, xa, ya, xb, yb, rx, ry)

    // io.debug(#(#(a_count, b_count), valid))
    case valid {
      True -> Ok(#(a_count, b_count))
      False -> Error(Nil)
    }
  })
  |> list.map(fn(counts) {
    let #(a_count, b_count) = counts
    3 * a_count + b_count
  })
  |> int.sum
}

pub fn parse(in) {
  in |> string.trim() |> string.split("\n\n") |> list.map(parse_machine)
}

pub fn parse_machine(in) {
  let assert [a, b, r] = in |> string.split("\n")
  [get_xy(a), get_xy(b), get_xy(r)] |> list.flatten
}

pub fn get_first_num(in) {
  let assert Ok(match_num) = regexp.from_string("(\\d+)")
  let matches = regexp.scan(match_num, in)
  let assert Ok(match) = list.first(matches)
  match.submatches
  |> list.first()
  |> result.unwrap(None)
  |> option.unwrap("0")
  |> int.parse
  |> result.unwrap(0)
}

pub fn get_xy(in) {
  string.split(in, ",") |> list.map(get_first_num)
}

// Legend
// Button A: X+(xa), Y+(ya)
// Button B: X+(xb), Y+(yb)
// Prize: X=(rx), Y=(ry)
fn get_counts(xa, ya, xb, yb, rx, ry) {
  let b = get_b_count(xa, ya, xb, yb, rx, ry)
  let a = get_a_count(rx, xb, xa, b)
  #(a, b)
}

// Validate that the counts come to the same result
// They won't if the minimum x,y answer is a float rather
// than whole numbers
fn is_counts_valid(a_count, b_count, xa, ya, xb, yb, rx, ry) {
  { { a_count * xa } + { b_count * xb } == rx }
  && { a_count * ya } + { b_count * yb } == ry
}

fn get_b_count(xa, ya, xb, yb, rx, ry) {
  { { xa * ry } - { ya * rx } } / { { xa * yb } - { ya * xb } }
}

fn get_a_count(rx, xb, xa, b) {
  { rx - { xb * b } } / xa
}
