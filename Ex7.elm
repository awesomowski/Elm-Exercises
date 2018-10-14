module Ex7 exposing (..)

import Json.Decode exposing (..)


-- Short guide: https://guide.elm-lang.org/interop/json.html
-- Docs: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode
-- Useful library for more complicated JSON schemas: http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest
{-
   Part 1
   Primitive values

   Run:
   - elm repl
   - import Ex7 exposing (..)

   Usually JSON comes from the server as a string and needs to be parsed or decoded to JS (or Elm values in our case).
   We will use decodeString function:

   decodeString : Decoder a -> String -> Result String a

   It takes decoder, which tells what value exactly we want, then it takes JSON string, and returns result (it can be success or failure)
   Let's start with simple values: int, string, float, bool

   1. Investigate types of all results: i, s, f, b
-}


i =
    decodeString int "7"


s =
    decodeString string "\"This is my string\""


f =
    decodeString float "3.14"


b =
    decodeString bool "true"



{-
   Docs for Result type:
   http://package.elm-lang.org/packages/elm-lang/core/latest/Result

   Why all values above are of a type: Result String val,
   where val is Int, String, Float or Bool?

   2. Examine err below

      Err type is a String, so String from the Result above is an error message!
-}


err =
    decodeString int "no number here"



{-
   3. Decoding Objects.
      Whenever we need to parse some objects with properties, we can use `field` decoder:

      field "propertyName" primitiveDecoder
-}


x =
    decodeString (field "x" int) """{ "x": 1, "y": 1 }"""



{-
   4. What happens when you decode an empty object?

   Try to write decoder for object which contains field `name` of type string, but you try to decode field `age` of type int.
   Hint you can use triple quotes to avoid escaping special characters like \"
   """{ }"""
-}


emptyObj =
    decodeString (field "name" string) "{}"


wrongJson =
    """{ "name": "Mary"}"""



-- TODO decode wrongJson as described in point 4.
-- wrongProperty =
--     decodeString
{-
   5. Decoding objects with multiple properties
      In Elm we need records to represent objects with multiple properties.
      In order to decode such object, we use functions map, map2, map3, ... up to 8.
-}


type alias Pet =
    { name : String
    , age : Int
    }


lessie =
    let
        petDecoder =
            map2 Pet (field "name" string) (field "age" int)
    in
        decodeString petDecoder """{ "name": "Lessie", "age": 3, "notused": true }"""



{-
   6. Decoding nested objects.
      What if you need to retrieve data from the JSON object which contains hierarchy of nested objects?
      Use `at` decoder!
      Check the type of `nested` below:
-}


nested =
    decodeString (at [ "result", "stars" ] int) """{ "result": { "stars": 17 } }"""


json =
    """{
    "result": {
        "book": {
            "id": 1348208,
            "subject": "Samochody",
            "author": "Hankiewicz, Tomasz. Tomtała, Szymon. Magdziarek, Radek.",
            "title": "Encyklopedia samochodów",
            "kind": "e-book",
            "genre": "Dokumenty elektroniczne Encyklopedia"
        }
    }
}"""



{-
   7. Write type alias for the book record, then decode JSON listed above.
      You can use all properties or only a few - feel free to experiment with it!
      Hints:
       -  mapX, where X is a number of props can be useful
       - let ... in ... expression helps to clean your code
-}
-- type alias Book =
-- book =
{-
   8. Sometimes you want to return const value and ignore what you find in JSON (however it must be valid JSON!)
      You can use `succeed` or `fail` decoders.
-}


success =
    decodeString (succeed 13) "false"


failure =
    decodeString (fail "Custom error message") "true"



{-
   9. Decoding lists
      Often we need to decode a list of primitive values or objects.
      There is a list decoder for that.
      Try to decode a list of pets using given petsJSON.
-}


myList =
    let
        listDecoder =
            list int
    in
        decodeString listDecoder "[ 1, 3, 5 ]"


petsJSON =
    """
[
    {
        "name": "Szarik",
        "age": 30
    },
    {
        "name": "Lessie",
        "age": 40
    },
    {
        "name": "Flipper",
         "age": 20
    }
]
"""



-- pets =
{-
   There are still many very useful decoders we haven't touched yet, to name a few: oneOf, null, maybe, index, nullable, andThen, dict, array, or lazy,
   which you can find in the documentation (link can be found on top of this file).
   Good luck and have fun with JSON decoders!
-}
