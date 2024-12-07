import day7
import day6
import gleam/io
import simplifile

pub type DateTime

// An external function that creates an instance of the type
@external(erlang, "os", "timestamp")
pub fn now() -> DateTime

pub fn main() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day7")

  io.debug(now())

  in
  |> day7.solve
  |> io.debug

  io.debug(now())
}
