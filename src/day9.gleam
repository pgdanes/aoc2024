import gleam/int
import gleam/list
import gleam/string

pub fn solve(input: String) {
  let blocks = parse(input)
  let processed = process(blocks)

  processed
  |> list.index_fold(0, fn(acc, f, index) {
    case f {
      File(x) -> acc + { index * x }
      _ -> acc
    }
  })
}

pub fn process(blocks: List(Block)) {
  let file_blocks =
    blocks
    |> list.filter(fn(x) {
      case x {
        File(_) -> True
        _ -> False
      }
    })

  let file_length = list.length(file_blocks)

  process_rec(blocks, list.reverse(blocks), [])
  |> list.reverse()
  |> list.take(file_length)
}

pub fn process_rec(
  file_blocks: List(Block),
  reverse_file_blocks: List(Block),
  acc: List(Block),
) {
  case file_blocks, reverse_file_blocks {
    [File(x), ..rest], _ -> {
      process_rec(rest, reverse_file_blocks, [File(x), ..acc])
    }
    [Empty, ..rest], [File(x), ..rest_reversed] -> {
      process_rec(rest, rest_reversed, [File(x), ..acc])
    }
    rest, [Empty, ..rest_reversed] -> {
      process_rec(rest, rest_reversed, acc)
    }
    _, _ -> acc
  }
}

pub fn debug(blocks: List(Block)) {
  blocks
  |> list.fold("", fn(acc, block) {
    case block {
      File(x) -> acc <> int.to_string(x)
      Empty -> acc <> "."
    }
  })
}

pub fn parse(input: String) {
  input
  |> string.trim_end()
  |> string.to_graphemes()
  |> list.index_fold([], fn(acc, curr, index) {
    let is_file = index % 2 == 0
    let file_index = index / 2
    let assert Ok(size) = int.parse(curr)

    let file = list.repeat(File(file_index), size)
    let empty = list.repeat(Empty, size)

    case is_file {
      True -> [file, ..acc]
      False -> [empty, ..acc]
    }
  })
  |> list.reverse
  |> list.flatten
}

pub type Block {
  File(id: Int)
  Empty
}
