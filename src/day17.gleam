import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Computer {
  Computer(
    program: String,
    iptr: Int,
    reg_a: Int,
    reg_b: Int,
    reg_c: Int,
    output: List(Int),
  )
}

pub fn new_computer() {
  Computer(program: "", reg_a: 0, reg_b: 0, reg_c: 0, iptr: 0, output: [])
}

/// This works by solving the last part and working it's way backwards
/// 1. initially try all values of 0-7 in reg a and find the value of a that will output "0"
/// 2. using that list of values, multiply each by 8 and then iterate through 0-7 for that 
///   to see which values will then output the next end "3,0"
/// NOTE: I saw a trend of 8 by brute forcing originally, but believe this works because 
///       OUT instruction modulo's the operand by 8
/// 3. iterate, trying out each - a DFS
///
/// e.g. 
/// [3] = "0"
/// [24, 31] = "3,0"
/// [199, 255, ...] = "3,3,0"
/// etc..
pub fn get_quine(program, i, a) {
  let drop_amount = string.length(program) - { i * 2 + 1 }
  let partial_program = string.drop_start(program, drop_amount)
  io.debug(#(i, a, partial_program))

  let valid_candidates =
    list.range(0, 7)
    |> list.filter_map(fn(n) {
      let candidate = { 8 * a } + n
      let output =
        Computer(..new_computer(), reg_a: candidate)
        |> load_program(program)
        |> execute_program()
        |> get_output()

      case output == partial_program {
        True -> Ok(#(candidate, output))
        False -> Error(Nil)
      }
    })

  let solution = valid_candidates |> list.find(fn(c) { c.1 == program })
  case solution {
    Ok(s) -> [s.0]
    Error(_) -> {
      io.debug(valid_candidates)
      valid_candidates
      |> list.flat_map(fn(c) { get_quine(program, i + 1, c.0) })
    }
  }
}

pub type Opcode {
  ADV(Int)
  BXL(Int)
  BST(Int)
  JNZ(Int)
  BXC(Int)
  OUT(Int)
  BDV(Int)
  CDV(Int)
}

pub fn load_program(computer: Computer, program: String) {
  let cleaned = string.replace(program, ",", "")
  Computer(..computer, program: cleaned)
}

pub fn execute_program(computer: Computer) {
  let execute_program_step = fn() {
    use opcode <- result.try(get_next_opcode(computer))
    use next_computer <- result.try(execute_opcode(computer, opcode))
    Ok(next_computer)
  }

  case execute_program_step() {
    Ok(next) -> execute_program(next)
    Error(_) -> computer
  }
}

pub fn get_next_opcode(computer: Computer) {
  let next_opcode_chars =
    string.drop_start(computer.program, computer.iptr)
    |> string.to_graphemes()
    |> list.take(2)
    |> list.filter_map(int.parse)

  case next_opcode_chars {
    [0, x] -> Ok(ADV(x))
    [1, x] -> Ok(BXL(x))
    [2, x] -> Ok(BST(x))
    [3, x] -> Ok(JNZ(x))
    [4, x] -> Ok(BXC(x))
    [5, x] -> Ok(OUT(x))
    [6, x] -> Ok(BDV(x))
    [7, x] -> Ok(CDV(x))
    _ -> Error(Nil)
  }
}

pub fn get_output(computer: Computer) {
  list.reverse(computer.output)
  |> list.map(int.to_string)
  |> string.join(",")
}

fn get_combo_operand(computer: Computer, operand: Int) {
  case operand {
    x if x >= 0 && x <= 3 -> x
    4 -> computer.reg_a
    5 -> computer.reg_b
    6 -> computer.reg_c
    x -> panic as { "invalid operand: " <> int.to_string(x) }
  }
}

fn execute_opcode(computer: Computer, opcode: Opcode) {
  case opcode {
    ADV(combo) -> execute_div(computer, combo, A)
    BXL(literal) -> execute_bxl(computer, literal)
    BST(combo) -> execute_bst(computer, combo)
    JNZ(literal) -> execute_jnz(computer, literal)
    BXC(_) -> execute_bxc(computer)
    OUT(combo) -> execute_out(computer, combo)
    BDV(combo) -> execute_div(computer, combo, B)
    CDV(combo) -> execute_div(computer, combo, C)
  }
}

fn execute_bxl(computer: Computer, literal: Int) {
  Ok(
    Computer(
      ..computer,
      iptr: computer.iptr + 2,
      reg_b: int.bitwise_exclusive_or(computer.reg_b, literal),
    ),
  )
}

fn execute_bst(computer: Computer, combo: Int) {
  let combo_value = get_combo_operand(computer, combo)
  use result <- result.try(int.modulo(combo_value, 8))

  Ok(Computer(..computer, iptr: computer.iptr + 2, reg_b: result))
}

fn execute_jnz(computer: Computer, literal: Int) {
  case computer.reg_a {
    0 -> Ok(Computer(..computer, iptr: computer.iptr + 2))
    _ -> Ok(Computer(..computer, iptr: literal))
  }
}

fn execute_bxc(computer: Computer) {
  let result = int.bitwise_exclusive_or(computer.reg_b, computer.reg_c)
  Ok(Computer(..computer, iptr: computer.iptr + 2, reg_b: result))
}

fn execute_out(computer: Computer, combo: Int) {
  let combo_value = get_combo_operand(computer, combo)
  use result <- result.try(int.modulo(combo_value, 8))
  Ok(
    Computer(
      ..computer,
      iptr: computer.iptr + 2,
      output: [result, ..computer.output],
    ),
  )
}

pub type Reg {
  A
  B
  C
}

fn execute_div(computer: Computer, combo: Int, target_reg: Reg) {
  let combo_value = get_combo_operand(computer, combo)
  use combo_powered <- result.try(int.power(2, int.to_float(combo_value)))
  use result <- result.try(float.divide(
    int.to_float(computer.reg_a),
    combo_powered,
  ))
  let truncated = float.truncate(result)

  case target_reg {
    A -> Ok(Computer(..computer, iptr: computer.iptr + 2, reg_a: truncated))
    B -> Ok(Computer(..computer, iptr: computer.iptr + 2, reg_b: truncated))
    C -> Ok(Computer(..computer, iptr: computer.iptr + 2, reg_c: truncated))
  }
}

pub fn debug_computer(computer: Computer) {
  io.println_error("Computer: ")
  io.println_error("iptr: " <> int.to_string(computer.iptr))
  io.println_error("reg_a: " <> int.to_string(computer.reg_a))
  io.println_error("reg_b: " <> int.to_string(computer.reg_b))
  io.println_error("reg_c: " <> int.to_string(computer.reg_c))
  io.println_error("output: " <> get_output(computer))
  io.println_error("")
  computer
}
