import day21
import gleam/io

pub fn day21_test() {
  "029A
980A
179A
456A
379A"
  |> day21.solve()
  |> io.debug
}

pub fn day21_real_test() {
  "670A
974A
638A
319A
508A
"
  |> day21.solve()
  |> io.debug
}
