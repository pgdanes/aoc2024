import day14
import gleam/io
import simplifile

pub type DateTime

@external(erlang, "os", "timestamp")
pub fn now() -> DateTime

pub fn main() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day14")

  io.debug(now())

  in
  |> day14.solve_b

  io.debug(now())
}
