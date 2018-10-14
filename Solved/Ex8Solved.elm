module Ex8Solved exposing (..)

import Array
import Json.Encode as Encode


-- Docs: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Encode
{-
   Run:
   - elm repl
   - import Ex8Solved exposing (..)

   Part 1
   Primitive values
   In order to encode Elm values to Json.Encode.Value type, primitive values encoders can be used (see examples below).
-}


s =
    Encode.string "Thix is some text"


i =
    Encode.int 7


f =
    Encode.float 3.14


b =
    Encode.bool True



-- We can have null inside Json, right?


n =
    Encode.null



{-
   To create list of values, use list
-}


numbersList =
    Encode.list Encode.int [ 1, 2, 3 ]



{-
   To create object, use object function
-}


o =
    [ ( "name", Encode.string "Mike" )
    , ( "surname", Encode.string "Wazowski" )
    , ( "id", Encode.int 123 )
    , ( "points", numbersList )
    ]
        |> Encode.object



{-
   In order to obtain a string with encoded JSON Value, use `encode` function.
   Test it on all Json values from this file.
   encode 0 val
   0 means no indentation - feel free to experiment with this integer value!
-}


sStr =
    Encode.encode 0 s


iStr =
    Encode.encode 4 i


fStr =
    Encode.encode 0 f


bStr =
    Encode.encode 0 b


nStr =
    Encode.encode 0 n


nlStr =
    Encode.encode 4 numbersList


oStr =
    Encode.encode 4 o



{-
   Exercise: try to encode some nested JSON object hierarchy and check if the produced string is ok.
-}


nested =
    Encode.object
        [ ( "data"
          , Encode.list Encode.object 
                [ [ ( "x", Encode.int 1 ), ( "y", Encode.int 1 ) ]
                , [ ( "x", Encode.int 2 ), ( "y", Encode.int 2 ) ]
                , [ ( "x", Encode.int 3 ), ( "y", Encode.int 3 ) ]
                ]
          )
        ]


nestedStr =
    Encode.encode 4 nested



{-
   Such JSON object encoded as a string can be, for example, sent to a server in HTTP request body.
-}
