import gleam/dict
import char
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn solve(input: String) {
  0
}

pub fn parse(input: String) {
  input 
  |> string.split("\n")
  |> list.map(string.to_graphemes)
}
