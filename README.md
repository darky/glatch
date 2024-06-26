# glatch

[![Package Version](https://img.shields.io/hexpm/v/glatch)](https://hex.pm/packages/glatch)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glatch/)

![logo](logo.jpg)

Gleam type check using pattern matching

```sh
gleam add glatch
```


```gleam
import glatch.{IsString}
import gleam/string

pub fn main() {
  case glatch.get_type("Lucy") {
    IsString(_) -> "Hello, 𓇼"
    unknown -> "Who are you? " <> string.inspect(unknown)
  }
}
```

Further documentation can be found at <https://hexdocs.pm/glatch>.

## Current status

#### Native / Stdlib

- [x] String
- [x] Int
- [x] Float
- [x] Bool
- [x] List
  - [x] nested type check
  - [x] empty type check
- [x] Option
  - [x] Some type check
  - [x] None type check  
- [x] Result
  - [x] Ok type check
  - [x] Error type check  
- [x] Dict
  - [x] key type check
  - [x] value type check
  - [x] empty type check 
- [x] Tuple
  - [x] Arity 0-6 

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
