// import day4
// import gleam/io
// import gleeunit/should
// import simplifile
//
// //   0        9
// // 0 MMMSXXMASM
// //   MSAMXMSMSA
// //   AMXSXMAAMM
// //   MSAMASMSMX
// //   XMASAMXAMM
// //   XXAMMXXAMA
// //   SMSMSASXSS
// //   SAXAMASAAA
// //   MAMMMXMMMM
// // 9 MXMXAXMASX
//
// pub fn day4_solve_test() {
//   let in =
//     "
// ....XXMAS.
// .SAMXMS...
// ...S..A...
// ..A.A.MS.X
// XMASAMX.MM
// X.....XA.A
// S.S.S.S.SS
// .A.A.A.A.A
// ..M.M.M.MM
// .X.X.XMASX"
//
//   in
//   |> day4.solve()
//   |> should.equal(18)
// }
//
// pub fn day4_real_test() {
//   let assert Ok(in) = simplifile.read(from: "test/inputs/day4")
//
//   in
//   |> day4.solve()
// }
//
// pub fn day4_b_test() {
//   "
// .M.S......
// ..A..MSMS.
// .M.S.MAA..
// ..A.ASMSM.
// .M.S.M....
// ..........
// S.S.S.S.S.
// .A.A.A.A..
// M.M.M.M.M.
// .........."
//   |> day4.solve_b()
//   |> should.equal(9)
// }
//
// pub fn day4_b_real_test() {
//   let assert Ok(in) = simplifile.read(from: "test/inputs/day4")
//
//   in
//   |> day4.solve_b()
//   |> should.equal(1925)
// }
