module Ex2 exposing (..)

{-
   1. Run `elm-test` command in the root folder
      If not installed run `npm install -g elm-test`
   2. Go to `tests/Tests.elm`
   3. Review the tests - they will serve you as a guideline for implementation and successfull finishing of exercises you will find below.
   4. In `Tests.elm` is also described alternative way to run tests in your browser.

   Hint: you can run `elm-test --watch` to launch tests automatically, whenever any elm file changes.
   Hint: notice the <| operator, it's defined here: http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#<|

   0.
     Maybe is actually defined as:
       type Maybe a
         = Just a
         | Nothing
     "type" (in contrast to type alias) allows us to declare union types

    Our application has following Selection union type that defines possible selection modes:
-}


type Selection
    = Empty
    | Single String
    | Multiple (List String)



{-
   Union types hold only one of possible values at the time.
   You can split your logic based on runtime value through pattern matching with 'case' operator

    something = Just "value"
    case maybe of
        Nothing ->
            "Empty"

        Just value ->
            "Value: " ++ value

-}
{- 1. Fix failing tests
   - what will be the type annotation of selectionToValues?
-}


selectionToValues selection =
    []



{-
   2. Back to lists!
      Uncomment second set of tests and implement function extendSelection
      - "cons" operator (::) adds item to the front of the list: (::) : a -> List a -> List a
-}


extendSelection value selection =
    Empty



{-
   3. It turns out we need additional logic for processing of custom items!
      Add new possible value to Selection type that holds String and CustomItemData, name it Advanced
      - talk with your compiler to get every regression fixed
      - assume Advanced selection cannot be extended and returns original selection
-}


type alias CustomItemData =
    { description : String
    , features : List Int
    }



{-
   4. Pattern matching on lists:
      Uncomment next set of tests and implement toSelection function
      - you can match (case .. of) on elements, e.g. [], [single], [first, second]
-}


toSelection : List String -> Selection
toSelection values =
    Empty



{-
   5. Processing
      Uncomment next set of tests and implement filteredToUppercaseString function
      - "bananas" have to be filtered out (case insensitive)

      - pipe (|>) operator
      - consider reusing selectionToValues
      - hint: List.map, String.toUpper, List.filter
      - definitions:
        http://package.elm-lang.org/packages/elm-lang/core/latest/List
        http://package.elm-lang.org/packages/elm-lang/core/latest/String
-}


filteredToUppercaseString : Selection -> List String
filteredToUppercaseString selection =
    []
