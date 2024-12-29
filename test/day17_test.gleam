// import day17.{Computer, new_computer}
// import gleam/io
// import gleam/list
// import gleeunit/should
//
// pub fn day17_example_test() {
//   Computer(..new_computer(), reg_c: 9)
//   |> day17.load_program("2,6")
//   |> day17.execute_program()
//   |> fn(c) { c.reg_b |> should.equal(1) }
//
//   Computer(..new_computer(), reg_a: 10)
//   |> day17.load_program("5,0,5,1,5,4")
//   |> day17.execute_program()
//   |> day17.get_output()
//   |> should.equal("0,1,2")
//
//   Computer(..new_computer(), reg_a: 2024)
//   |> day17.load_program("0,1,5,4,3,0")
//   |> day17.execute_program()
//   |> day17.get_output()
//   |> should.equal("4,2,5,6,7,7,7,7,3,1,0")
//
//   Computer(..new_computer(), reg_b: 29)
//   |> day17.load_program("1,7")
//   |> day17.execute_program()
//   |> fn(c) { c.reg_b |> should.equal(26) }
//
//   Computer(..new_computer(), reg_b: 2024, reg_c: 43_690)
//   |> day17.load_program("4,0")
//   |> day17.execute_program()
//   |> fn(c) { c.reg_b |> should.equal(44_354) }
//
//   Computer(..new_computer(), reg_a: 729)
//   |> day17.load_program("0,1,5,4,3,0")
//   |> day17.execute_program()
//   |> day17.get_output()
//   |> should.equal("4,6,3,5,6,3,5,2,1,0")
// }
//
// pub fn day17_real_test() {
//   Computer(..new_computer(), reg_a: 53_437_164)
//   |> day17.load_program("2,4,1,7,7,5,4,1,1,4,5,5,0,3,3,0")
//   |> day17.execute_program()
//   |> day17.get_output()
// }
//
// pub fn day17_b_scratch_test() {
//   Computer(..new_computer(), reg_a: 117_440)
//   |> day17.load_program("0,3,5,4,3,0")
//   |> day17.execute_program()
//   |> day17.get_output()
//   |> io.debug
// }
//
// pub fn day17_b_real_test() {
//   day17.get_quine("2,4,1,7,7,5,4,1,1,4,5,5,0,3,3,0", 0, 0)
//   |> io.debug
// }
