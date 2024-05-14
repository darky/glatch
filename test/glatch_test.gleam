import glatch.{
  IsBool, IsDict, IsEmpty, IsFloat, IsInt, IsList, IsNotFound, IsOption,
  IsResult, IsString, IsTuple0, IsTuple1, IsTuple2, IsTuple3, IsTuple4, IsTuple5,
  IsTuple6,
}
import gleam/dict
import gleam/dynamic
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

type ForNotFound {
  ForNotFound
}

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

pub fn dynamic_test() {
  case glatch.get_type(dynamic.from("ok")) {
    IsString(s) -> s
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn dict_key_test() {
  case glatch.get_type(dict.from_list([#("test-key", "test-value")])) {
    IsDict(IsString(s), _) -> s
    _ -> "fail"
  }
  |> should.equal("test-key")
}

pub fn dict_value_test() {
  case glatch.get_type(dict.from_list([#("test-key", "test-value")])) {
    IsDict(_, IsString(s)) -> s
    _ -> "fail"
  }
  |> should.equal("test-value")
}

pub fn dict_empty_test() {
  case glatch.get_type(dict.from_list([])) {
    IsDict(IsEmpty, IsEmpty) -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn not_found_test() {
  case glatch.get_type(ForNotFound) {
    IsNotFound -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn tuple_empty_test() {
  case glatch.get_type(#()) {
    IsTuple0 -> "ok"
    _ -> "fail"
  }
  |> should.equal("ok")
}

pub fn tuple_1_test() {
  case glatch.get_type(#("test")) {
    IsTuple1(IsString(s)) -> s
    _ -> "fail"
  }
  |> should.equal("test")
}

pub fn tuple_2_test() {
  case glatch.get_type(#("test1", "test2")) {
    IsTuple2(IsString(s1), IsString(s2)) -> [s1, s2]
    _ -> []
  }
  |> should.equal(["test1", "test2"])
}

pub fn tuple_3_test() {
  case glatch.get_type(#("test1", "test2", "test3")) {
    IsTuple3(IsString(s1), IsString(s2), IsString(s3)) -> [s1, s2, s3]
    _ -> []
  }
  |> should.equal(["test1", "test2", "test3"])
}

pub fn tuple_4_test() {
  case glatch.get_type(#("test1", "test2", "test3", "test4")) {
    IsTuple4(IsString(s1), IsString(s2), IsString(s3), IsString(s4)) -> [
      s1,
      s2,
      s3,
      s4,
    ]
    _ -> []
  }
  |> should.equal(["test1", "test2", "test3", "test4"])
}

pub fn tuple_5_test() {
  case glatch.get_type(#("test1", "test2", "test3", "test4", "test5")) {
    IsTuple5(
      IsString(s1),
      IsString(s2),
      IsString(s3),
      IsString(s4),
      IsString(s5),
    ) -> [s1, s2, s3, s4, s5]
    _ -> []
  }
  |> should.equal(["test1", "test2", "test3", "test4", "test5"])
}

pub fn tuple_6_test() {
  case
    glatch.get_type(#("test1", "test2", "test3", "test4", "test5", "test6"))
  {
    IsTuple6(
      IsString(s1),
      IsString(s2),
      IsString(s3),
      IsString(s4),
      IsString(s5),
      IsString(s6),
    ) -> [s1, s2, s3, s4, s5, s6]
    _ -> []
  }
  |> should.equal(["test1", "test2", "test3", "test4", "test5", "test6"])
}
