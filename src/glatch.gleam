import gleaf
import gleam/bool
import gleam/dict
import gleam/dynamic
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gledo
import gluple

pub type MatchedType(x) {
  IsInt(Int)
  IsString(String)
  IsBool(Bool)
  IsFloat(Float)
  IsList(MatchedType(x))
  IsOption(Option(MatchedType(x)))
  IsResult(Result(MatchedType(x), MatchedType(x)))
  IsDict(MatchedType(x), MatchedType(x))
  IsTuple0
  IsTuple1(MatchedType(x))
  IsTuple2(MatchedType(x), MatchedType(x))
  IsTuple3(MatchedType(x), MatchedType(x), MatchedType(x))
  IsTuple4(MatchedType(x), MatchedType(x), MatchedType(x), MatchedType(x))
  IsTuple5(
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
  )
  IsTuple6(
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
    MatchedType(x),
  )
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
        try_tuple,
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
  use <- bool.guard(gluple.is_tuple(item), Error([]))
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

fn try_tuple(item) {
  use <- bool.guard(gluple.is_tuple(item) == False, Error([]))
  let assert Ok(size) = gluple.tuple_size(item)
  use <- bool.guard(size == 0, Ok(IsTuple0))
  use <- bool.guard(size > 6, Error([]))
  let assert Ok(tuple_as_list) = gluple.tuple_to_list(item)
  tuple_as_list
  |> list.map(fn(x) { get_type(x) })
  |> gleaf.apply(case size {
    1 -> dynamic.from(IsTuple1)
    2 -> dynamic.from(IsTuple2)
    3 -> dynamic.from(IsTuple3)
    4 -> dynamic.from(IsTuple4)
    5 -> dynamic.from(IsTuple5)
    6 -> dynamic.from(IsTuple6)
    _ -> panic as "impossible"
  })
  |> Ok
}
