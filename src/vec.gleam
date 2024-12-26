pub type Vector =
  #(Int, Int)

pub type BoundingBox =
  #(Int, Int)

pub fn add(a: Vector, b: Vector) {
  #(a.0 + b.0, a.1 + b.1)
}

pub fn sub(a: Vector, b: Vector) {
  #(a.0 - b.0, a.1 - b.1)
}

pub fn distance(a, b) {
  sub(b, a)
}

pub fn reverse(a: Vector) {
  #(-a.0, -a.1)
}

pub fn is_in_bounds(a: Vector, box: BoundingBox) {
  a.0 >= 0 && a.0 < box.0 && a.1 >= 0 && a.1 < box.1
}
