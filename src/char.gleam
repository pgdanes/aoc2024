pub fn is_num(c: String) {
  case c {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

pub fn is_left_paren(c) {
  c == "("
}

pub fn is_comma(c) {
  c == ","
}

pub fn is_right_paren(c) {
  c == ")"
}
