// import simplifile
// import gleam/dict
// import day14
// import gleam/io
// import gleam/list

// pub fn day14_real_test() {
//   let assert Ok(in) = simplifile.read(from: "test/inputs/day14")
//
//   in
//   |> day14.solve_b
// }

// pub fn day14_scratch_test() {
//   let robots =
//     "p=0,4 v=3,-3
// p=6,3 v=-1,-3
// p=10,3 v=-1,2
// p=2,0 v=2,-1
// p=0,0 v=1,3
// p=3,0 v=-2,-2
// p=7,6 v=-1,-3
// p=3,0 v=-1,-2
// p=9,3 v=2,3
// p=7,3 v=-1,2
// p=2,4 v=2,-3
// p=9,5 v=-3,-3"
//     |> day14.parse
//
//   day14.draw_map(robots, #(11, 7))
//   io.println_error("")
//
//   let moved =
//     robots
//     |> list.filter_map(day14.move_robot(_, 100, #(11, 7)))
//
//
//   day14.draw_map(moved, #(11, 7))
//   io.println_error("")
//
//   moved
//   |> day14.get_safety_factor(#(11, 7))
//   |> io.debug
// }
