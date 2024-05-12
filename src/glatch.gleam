import gleam/dict
import gleam/dynamic
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gledo

pub type MatchedType(x) {
  IsInt(Int)
  IsString(String)
  IsBool(Bool)
  IsFloat(Float)
  IsList(MatchedType(x))
  IsOption(Option(MatchedType(x)))
  IsResult(Result(MatchedType(x), MatchedType(x)))
  IsDict(MatchedType(x), MatchedType(x))
  IsNotFound
  IsEmpty
}

pub fn get_type(item: t) {
  let dyn = dynamic.from(item)
  let resp =
    list.find_map(
      [
        try_int,
        try_float,
        try_string,
        try_bool,
        try_list,
        try_dict,
        try_result,
        try_optional,
      ],
      fn(type_check) { type_check(dyn) },
    )
  case resp {
    Ok(resp) -> resp
    Error(Nil) -> IsNotFound
  }
}

fn try_int(item) {
  dynamic.int(item)
  |> result.map(fn(r) { IsInt(r) })
}

fn try_string(item) {
  dynamic.string(item)
  |> result.map(fn(r) { IsString(r) })
}

fn try_bool(item) {
  dynamic.bool(item)
  |> result.map(fn(r) { IsBool(r) })
}

fn try_float(item) {
  dynamic.float(item)
  |> result.map(fn(r) { IsFloat(r) })
}

fn try_list(item) {
  dynamic.shallow_list(item)
  |> result.map(fn(r) {
    case list.first(r) {
      Ok(r) -> {
        r
        |> get_type
        |> IsList
      }
      Error(Nil) -> IsList(IsEmpty)
    }
  })
}

fn try_optional(item) {
  item
  |> gledo.decode_option
  |> result.map(fn(r) {
    case r {
      Some(r) -> {
        r
        |> get_type
        |> Some
        |> IsOption
      }
      None -> IsOption(None)
    }
  })
}

fn try_result(item) {
  item
  |> dynamic.result(dynamic.dynamic, dynamic.dynamic)
  |> result.map(fn(r) {
    case r {
      Ok(r) -> {
        r
        |> get_type
        |> Ok
        |> IsResult
      }
      Error(r) -> {
        r
        |> get_type
        |> Error
        |> IsResult
      }
    }
  })
}

fn try_dict(item) {
  item
  |> dynamic.dict(dynamic.dynamic, dynamic.dynamic)
  |> result.map(fn(r) {
    case dict.size(r) > 0 {
      True -> {
        let entities = dict.to_list(r)
        let assert Ok(#(key, val)) = list.first(entities)
        IsDict(get_type(key), get_type(val))
      }
      False -> IsDict(IsEmpty, IsEmpty)
    }
  })
}
