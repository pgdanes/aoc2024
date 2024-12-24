import gleam/int
import gleam/io
import gleam/list
import gleam/set
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

pub fn solve_b(input: String) {
  let spans = parse_b(input)
  process_b(spans)
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

pub fn parse_b(input: String) {
  input
  |> string.trim_end()
  |> string.to_graphemes()
  |> list.index_fold([], fn(acc, curr, index) {
    let is_file = index % 2 == 0
    let file_index = index / 2
    let assert Ok(size) = int.parse(curr)

    let file = FileSpan(file_index, size)
    let empty = EmptySpan(size)

    case is_file {
      True -> [file, ..acc]
      False -> [empty, ..acc]
    }
  })
  |> list.reverse
  |> list.filter(fn(x) {
    case x {
      EmptySpan(0) -> False
      _ -> True
    }
  })
}

pub fn checksum_b(spans: List(BlockSpan)) {
  checksum_b_rec(spans, 0, 0)
}

fn checksum_b_rec(spans: List(BlockSpan), offset: Int, acc: Int) {
  case spans {
    [] -> acc
    [EmptySpan(size), ..rest] -> checksum_b_rec(rest, offset + size, acc)
    [FileSpan(id, size), ..rest] -> {
      let file_total =
        list.range(offset, offset + size - 1)
        // |> io.debug
        |> list.map(fn(i) { i * id })
        // |> io.debug
        |> int.sum
      // |> io.debug

      checksum_b_rec(rest, offset + size, acc + file_total)
    }
  }
}

pub fn process_b(spans: List(BlockSpan)) {
  let assert Ok(FileSpan(id, _)) =
    spans |> list.reverse() |> list.filter(is_file_span) |> list.first()

  process_b_rec(spans, id, set.new(), [])
}

pub fn process_b_rec(spans, id_to_move, skipped, visited) {
  let file_to_move =
    list.find(spans, fn(x) {
      case x {
        FileSpan(id, _) -> id == id_to_move
        EmptySpan(_) -> False
      }
    })

  io.println_error("")
  io.debug(#("file to move", file_to_move))

  case file_to_move, spans {
    // haven't reached an empty space, just continue
    Ok(FileSpan(a_id, _)), [FileSpan(b_id, size), ..spans_rest] -> {
      case a_id == b_id {
        True -> {
          // io.debug("found own file adding to skip list")
          let reset_spans =
            [visited |> list.reverse(), [FileSpan(b_id, size)], spans_rest]
            |> list.flatten
          process_b_rec(
            reset_spans,
            id_to_move - 1,
            set.insert(skipped, b_id),
            [],
          )
        }
        False -> {
          // io.debug("continuing over file until finding empty space")
          process_b_rec(spans_rest, id_to_move, skipped, [
            FileSpan(b_id, size),
            ..visited
          ])
        }
      }
    }

    // empty space found, but too small
    // continue and see if any other empty spaces will fit it
    Ok(FileSpan(_, size)), [EmptySpan(space), ..spans_rest] if space < size -> {
      // io.debug("continuing over empty until finding empty space")
      process_b_rec(spans_rest, id_to_move, skipped, [
        EmptySpan(space),
        ..visited
      ])
    }

    // move file, theres space, then restart with new file
    Ok(FileSpan(id, size)), [EmptySpan(space), ..spans_rest] if space >= size -> {
      io.debug("found space")

      let new_blocks = case space == size {
        True -> [FileSpan(id, size)]
        False -> [FileSpan(id, size), EmptySpan(space - size)]
      }

      let others =
        spans_rest
        |> list.map(fn(x) {
          case x {
            FileSpan(other_id, other_size) if id == other_id ->
              EmptySpan(other_size)
            _ -> x
          }
        })

      let new_spans =
        [visited |> list.reverse(), new_blocks, others]
        |> list.flatten()

      process_b_rec(new_spans, id_to_move - 1, skipped, [])
    }

    Ok(FileSpan(id, _)), [] -> {
      // io.debug("reached end, adding to skip list")
      // we've skipped one, gotta restart to try new file
      let reset_spans = visited |> list.reverse()
      process_b_rec(reset_spans, id_to_move - 1, set.insert(skipped, id), [])
    }

    // we've run out of files to move
    Error(_), _ -> spans
    _, _ -> spans
  }
}

pub type Block {
  File(id: Int)
  Empty
}

pub type BlockSpan {
  FileSpan(id: Int, size: Int)
  EmptySpan(size: Int)
}

pub fn debug(blocks: List(Block)) {
  let debug_view =
    blocks
    |> list.fold("", fn(acc, block) {
      case block {
        File(x) -> acc <> int.to_string(x)
        Empty -> acc <> "."
      }
    })

  io.debug(debug_view)
  blocks
}

pub fn render_spans(spans) {
  spans
  |> list.fold([], fn(acc, span) {
    case span {
      FileSpan(id, size) -> [list.repeat(int.to_string(id), size), ..acc]
      EmptySpan(size) -> [list.repeat(".", size), ..acc]
    }
  })
  |> list.flatten
  |> list.fold("", fn(acc, x) { x <> acc })
}

pub fn debug_spans(spans: List(BlockSpan)) {
  io.debug(render_spans(spans))
  spans
}

pub fn is_file_span(span: BlockSpan) {
  case span {
    FileSpan(_, _) -> True
    _ -> False
  }
}
