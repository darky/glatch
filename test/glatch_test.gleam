import glatch
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn string_test() {
  case glatch.get_type("ok") {
    glatch.TString(x) -> x
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn int_test() {
  case glatch.get_type(1) {
    glatch.TInt(n) -> n
    _ -> 0
  }
  |> should.equal(1)
}

pub fn bool_test() {
  case glatch.get_type(True) {
    glatch.TBool(b) -> b
    _ -> False
  }
  |> should.equal(True)
}

pub fn float_test() {
  case glatch.get_type(1.0) {
    glatch.TFloat(f) -> f
    _ -> 0.0
  }
  |> should.equal(1.0)
}

pub fn empty_list_test() {
  case glatch.get_type([]) {
    glatch.TList(glatch.TEmpty) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn non_empty_list_test() {
  case glatch.get_type(["test"]) {
    glatch.TList(glatch.TString(s)) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}
