import gleam/int
import gleam/io
import gleam/list
import gleam/result
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

pub fn process_b(spans: List(BlockSpan)) {
  process_b_rec(spans, spans |> list.reverse, [], []) |> debug_spans
}

pub fn process_b_rec(spans, rev, skipped, acc) {
  io.debug(#("span", render_spans(spans)))
  io.debug(#("rev", render_spans(rev)))
  io.debug(#("acc", render_spans(acc |> list.reverse)))
  io.debug(#("skipped", render_spans(skipped |> list.reverse)))
  io.println_error("")

  case rev, spans {
    // move file, theres space
    rev, [FileSpan(id, size), ..spans_rest] -> {
      process_b_rec(spans_rest, rev, skipped, [FileSpan(id, size), ..acc])
    }

    // move file, theres space
    [FileSpan(id, size), ..rev_rest], [EmptySpan(space), ..spans_rest]
      if space >= size
    -> {
      case space == size {
        True ->
          process_b_rec(spans_rest, rev_rest, skipped, [
            FileSpan(id, size),
            ..acc
          ])
        False ->
          process_b_rec(
            [EmptySpan(space - size), ..spans_rest],
            rev_rest,
            skipped,
            [FileSpan(id, size), ..acc],
          )
      }
    }

    // no space
    [FileSpan(id, size), ..rev_rest], [EmptySpan(space), ..spans_rest]
      if space < size
    -> {
      process_b_rec(spans_rest, rev_rest, [FileSpan(id, size), ..skipped], [
        EmptySpan(space),
        ..acc
      ])
    }

    [EmptySpan(space), ..rev_rest], spans 
    -> {
      process_b_rec(spans, rev_rest, [EmptySpan(space), ..skipped], acc)
    }

    _, _ -> acc
  }
}

// pub fn try_compact_one(spans: List(BlockSpan)) {
//   use last <- result.try(list.last(spans))
//   try_compact_one_rec(spans, last, [])
// }
//
// fn try_compact_one_rec(
//   spans: List(BlockSpan),
//   span: BlockSpan,
//   skipped: List(BlockSpan),
// ) {
//   io.debug(#("spans", render_spans(spans)))
//   io.debug(#("skipped", render_spans(skipped)))
//
//   case spans, span {
//     // existing file
//     [FileSpan(id, size), ..rest], span -> {
//       try_compact_one_rec(rest, span, [FileSpan(id, size), ..skipped])
//     }
//
//     // can compact
//     [EmptySpan(space), ..rest], FileSpan(id, size) if space >= size -> {
//
//     // have empty but not big enough
//     [EmptySpan(space), ..], FileSpan(_, size) if space < size -> {
//       Error(Nil)
//     }
//
//     // why are you trying to compact with empty
//     _, EmptySpan(_) | [EmptySpan(_), ..], FileSpan(_, _) | [], _ -> Ok(spans)
//   }
// }

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
