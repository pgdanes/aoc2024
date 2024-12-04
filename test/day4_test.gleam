import day4
import day3.{Multiple}
import gleam/io
import gleam/list
import gleam/option.{None, Some}
pub fn day4_solve_test() {
"MMM
MSA
AMX"
  |> day4.parse
  |> io.debug()
}
