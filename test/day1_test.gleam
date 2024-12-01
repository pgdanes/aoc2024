import gleam/io
import day1
import gleeunit/should

pub fn day1_a_test() {
  let in =
"3   4
4   3
2   5
1   3
3   9
3   3"

  in |> day1.solve |> should.equal(11)
}

pub fn day1_a_parse_pair_test() {
  "64256   78813" |> day1.parse_pair() |> should.equal(Ok([64256, 78813]))
}

pub fn day1_real_subset_test() {
"64256   78813
46941   56838
47111   50531
48819   41511
54871   96958
97276   63446" |> day1.solve() |> io.debug()
}

