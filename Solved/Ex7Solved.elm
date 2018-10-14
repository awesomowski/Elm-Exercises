module Ex7Solved exposing (..)

import Json.Decode as Decode


-- Short guide: https://guide.elm-lang.org/interop/json.html
-- Docs: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode
-- Useful library for more complicated JSON schemas: http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest
{-
   Part 1
   Primitive values

   Run:
   - elm repl
   - import Ex7Solved exposing (..)

   Usually JSON comes from the server as a string and needs to be parsed or decoded to JS (or Elm values in our case).
   We will use decodeString function:

   decodeString : Decoder a -> String -> Result String a

   It takes decoder, which tells what value exactly we want, then it takes JSON string, and returns result (it can be success or failure)
   Let's start with simple values: int, string, float, bool

   1. Investigate types of all results: i, s, f, b
-}


i =
    Decode.decodeString Decode.int "7"


s =
    Decode.decodeString Decode.string "\"This is my string\""


f =
    Decode.decodeString Decode.float "3.14"


b =
    Decode.decodeString Decode.bool "true"



{-
   Docs for Result type:
   http://package.elm-lang.org/packages/elm-lang/core/latest/Result

   Why all values above are of a type: Result String val,
   where val is Int, String, Float or Bool?

   2. Examine err below

      Err type is a String, so String from the Result above is an error message!
-}


err =
    Decode.decodeString Decode.int "no number here"



{-
   3. Decoding Objects.
      Whenever we need to parse some objects with properties, we can use `field` decoder:

      field "propertyName" primitiveDecoder
-}


x =
    Decode.decodeString (Decode.field "x" Decode.int) """{ "x": 1, "y": 1 }"""



{-
   4. What happens when you decode an empty object?

   Try to write decoder for object which contains field `name` of type string, but you try to decode field `age` of type int.
   Hint you can use triple quotes to avoid escaping special characters like \"
   """{ }"""
-}


emptyObj =
    Decode.decodeString (Decode.field "name" Decode.string) "{}"


wrongJson =
    """{ "name": "Mary"}"""


wrongProperty =
    Decode.decodeString (Decode.field "age" Decode.int) wrongJson



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
            Decode.map2 Pet (Decode.field "name" Decode.string) (Decode.field "age" Decode.int)
    in
        Decode.decodeString petDecoder """{ "name": "Lessie", "age": 3, "notused": true }"""



{-
   6. Decoding nested objects.
      What if you need to retrieve data from the JSON object which contains hierarchy of nested objects?
      Use `at` decoder!
-}


nested =
    Decode.decodeString (Decode.at [ "result", "stars" ] Decode.int) """{ "result": { "stars": 17 } }"""


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


type alias Book =
    { id : Int
    , subject : String
    , author : String
    , title : String
    , kind : String
    , genre : String
    }


book =
    let
        bookDecoder =
            Decode.map6 Book
                (Decode.field "id" Decode.int)
                (Decode.field "subject" Decode.string)
                (Decode.field "author" Decode.string)
                (Decode.field "title" Decode.string)
                (Decode.field "kind" Decode.string)
                (Decode.field "genre" Decode.string)

        bookResultDecoder =
            Decode.at [ "result", "book" ] bookDecoder
    in
        Decode.decodeString bookResultDecoder json



{-
   8. Sometimes you want to return const value and ignore what you find in JSON (however it must be valid JSON!)
      You can use `succeed` or `fail` decoders.
-}


success =
    Decode.decodeString (Decode.succeed 13) "false"


failure =
    Decode.decodeString (Decode.fail "Custom error message") "true"



{-
   9. Decoding lists
      Often we need to decode a list of primitive values or objects.
      There is a list decoder for that.
      Try to decode a list of pets using given petsJSON.
-}


myList =
    let
        listDecoder =
            Decode.list Decode.int
    in
        Decode.decodeString listDecoder "[ 1, 3, 5 ]"


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


pets =
    let
        petDecoder =
            Decode.map2 Pet (Decode.field "name" Decode.string) (Decode.field "age" Decode.int)
    in
        Decode.decodeString (Decode.list petDecoder) petsJSON



{-
   There are still many very useful decoders we haven't touched yet, to name a few: oneOf, null, maybe, index, nullable, andThen, dict, array, or lazy,
   which you can find in the documentation (link can be found on top of this file).
   Good luck and have fun with JSON decoders!
-}
