import glatch.{TBool, TEmpty, TFloat, TInt, TList, TOption, TResult, TString}
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn string_test() {
  case glatch.get_type("ok") {
    TString(x) -> x
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn int_test() {
  case glatch.get_type(1) {
    TInt(n) -> n
    _ -> 0
  }
  |> should.equal(1)
}

pub fn bool_test() {
  case glatch.get_type(True) {
    TBool(b) -> b
    _ -> False
  }
  |> should.equal(True)
}

pub fn float_test() {
  case glatch.get_type(1.1) {
    TFloat(f) -> f
    _ -> 0.0
  }
  |> should.equal(1.1)
}

pub fn empty_list_test() {
  case glatch.get_type([]) {
    TList(TEmpty) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn non_empty_list_test() {
  case glatch.get_type(["test"]) {
    TList(TString(s)) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn option_some_test() {
  case glatch.get_type(Some("test")) {
    TOption(Some(TString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn option_none_test() {
  case glatch.get_type(None) {
    TOption(None) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn result_ok_test() {
  case glatch.get_type(Ok("test")) {
    TResult(Ok(TString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn result_error_test() {
  case glatch.get_type(Error("test")) {
    TResult(Error(TString(s))) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}
