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
  case glatch.get_type("world") {
    IsString(world) -> "Hello, " <> world
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
- [x] Result
- [x] Dict
  - [x] key type check
  - [x] value type check
  - [x] empty type check 


## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
