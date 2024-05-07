import glatch.{
  IsBool, IsEmpty, IsFloat, IsInt, IsList, IsOption, IsResult, IsString,
}
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn string_test() {
  case glatch.get_type("ok") {
    IsString(s) -> s
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn int_test() {
  case glatch.get_type(1) {
    IsInt(n) -> n
    _ -> 0
  }
  |> should.equal(1)
}

pub fn bool_test() {
  case glatch.get_type(True) {
    IsBool(b) -> b
    _ -> False
  }
  |> should.equal(True)
}

pub fn float_test() {
  case glatch.get_type(1.1) {
    IsFloat(f) -> f
    _ -> 0.0
  }
  |> should.equal(1.1)
}

pub fn empty_list_test() {
  case glatch.get_type([]) {
    IsList(IsEmpty) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn non_empty_list_test() {
  case glatch.get_type(["test"]) {
    IsList(IsString(s)) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn option_some_test() {
  case glatch.get_type(Some("test")) {
    IsOption(Some(IsString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn option_none_test() {
  case glatch.get_type(None) {
    IsOption(None) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn result_ok_test() {
  case glatch.get_type(Ok("test")) {
    IsResult(Ok(IsString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn result_error_test() {
  case glatch.get_type(Error("test")) {
    IsResult(Error(IsString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}
