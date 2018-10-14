module Ex2Solved exposing (..)

{-
   1. Run `elm-test` command in `Ex2` folder
      If not installed run `npm install -g elm-test`
   2. Go to `tests/Tests.elm`
   3. Review the tests - they will serve you as a guideline for implementation and successfull finishing of exercises you will find below.
   4. In `Tests.elm` is also described alternative way to run tests in your browser.

   Hint: you can run `elm-test --watch` to launch tests automatically, whenever any elm file changes.

   1.
     Maybe is actually defined as:
       type Maybe a
         = Just a
         | Nothing
     "type" (in contrast to type alias) allows us to declare union types
-}


type Selection
    = Empty
    | Single String
    | Multiple (List String)
    | Advanced String CustomItemData



{- 1.
   - <| operator is defined here: http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#<|
   - what will be the type annotation of selectionToValues?
-}


selectionToValues selection =
    case selection of
        Empty ->
            []

        Single value ->
            [ value ]

        Multiple values ->
            values

        Advanced value data ->
            [ value ]



{-
   2. Back to lists!
      Uncomment second set of tests and implement function extendSelection
      - "cons" operator (::) adds item to the front of the list: (::) : a -> List a -> List a
-}


extendSelection value selection =
    case selection of
        Empty ->
            Single value

        Single original ->
            Multiple [ value, original ]

        Multiple originalValues ->
            Multiple <| value :: originalValues

        Advanced v data ->
            selection



{-
   3. It turns out we need additional logic for processing of custom items!
      Add new possible value to Selection type that holds String and CustomItemData
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
    case values of
        [] ->
            Empty

        [ v ] ->
            Single v

        vs ->
            Multiple vs



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
    selection
        |> selectionToValues
        |> List.map String.toUpper
        |> List.filter (\v -> v /= "BANANAS")
