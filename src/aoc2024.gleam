import day8
import day9
import gleam/io
import simplifile

pub type DateTime

@external(erlang, "os", "timestamp")
pub fn now() -> DateTime

pub fn main() {
  let assert Ok(in) = simplifile.read(from: "test/inputs/day9")

  io.debug(now())

  in
  |> day9.solve_b
  |> day9.checksum_b
  |> io.debug

  io.debug(now())
}
