import day8
import gleam/io
import simplifile

pub type DateTime

@external(erlang, "os", "timestamp")
pub fn now() -> DateTime

pub fn main() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day8")

  io.debug(now())

  in
  |> day8.solve_b
  |> io.debug

  io.debug(now())
}
