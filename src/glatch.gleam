import gleam/dynamic
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

pub type MatchedType(x) {
  TInt(Int)
  TString(String)
  TBool(Bool)
  TFloat(Float)
  TList(MatchedType(x))
  TOption(Option(MatchedType(x)))
  TResult(Result(MatchedType(x), MatchedType(x)))
  TNotFound
  TEmpty
}

pub fn get_type(item: t) -> MatchedType(x) {
  let dyn = dynamic.from(item)
  let resp =
    list.find_map(
      [
        try_int,
        try_float,
        try_string,
        try_bool,
        try_list,
        try_optional,
        try_result,
      ],
      fn(type_check) { type_check(dyn) },
    )
  case resp {
    Ok(resp) -> resp
    Error(Nil) -> TNotFound
  }
}

fn try_int(item) -> Result(MatchedType(x), _) {
  dynamic.int(item)
  |> result.map(fn(r) { TInt(r) })
}

fn try_string(item) -> Result(MatchedType(x), _) {
  dynamic.string(item)
  |> result.map(fn(r) { TString(r) })
}

fn try_bool(item) -> Result(MatchedType(x), _) {
  dynamic.bool(item)
  |> result.map(fn(r) { TBool(r) })
}

fn try_float(item) -> Result(MatchedType(x), _) {
  dynamic.float(item)
  |> result.map(fn(r) { TFloat(r) })
}

fn try_list(item) -> Result(MatchedType(x), _) {
  dynamic.shallow_list(item)
  |> result.map(fn(r) {
    case list.first(r) {
      Ok(x) -> {
        x
        |> dynamic.dynamic
        |> result.map(fn(x) {
          x
          |> get_type
          |> TList
        })
      }
      Error(Nil) -> Ok(TList(TEmpty))
    }
  })
  |> result.flatten
}

fn try_optional(item) -> Result(MatchedType(x), _) {
  item
  |> dynamic.optional(dynamic.dynamic)
  |> result.map(fn(r) {
    case r {
      Some(r) -> {
        r
        |> dynamic.dynamic
        |> result.map(fn(r) {
          r
          |> get_type
          |> Some
          |> TOption
        })
      }
      None -> Ok(TOption(None))
    }
  })
  |> result.flatten
}

fn try_result(item) -> Result(MatchedType(x), _) {
  item
  |> dynamic.result(dynamic.dynamic, dynamic.dynamic)
  |> result.map(fn(r) {
    case r {
      Ok(r) -> {
        r
        |> dynamic.dynamic
        |> result.map(fn(r) {
          r
          |> get_type
          |> Ok
          |> TResult
        })
      }
      Error(r) -> {
        r
        |> dynamic.dynamic
        |> result.map(fn(r) {
          r
          |> get_type
          |> Error
          |> TResult
        })
      }
    }
  })
  |> result.flatten
}
