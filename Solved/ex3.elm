module Ex3 exposing(..)

import Html exposing (Html, button, div, text, p)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Dict



main = Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }

type alias Model = Int

type Msg 
    = Increment

initModel : Model
initModel = 
    0
    
update : Msg -> Model -> Model
update msg model =
    case msg of Increment
        -> model + 1

view : Model -> Html Msg
view model =
    div [] 
    [ 
      viewResult <| validate shiftedIndex
    , viewResult <| validateIndexedLetter indexList
    , viewResult <| validateReversed appendIndex
    , viewResult <| validateCipher encode
    , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "styles.css" ] []
    ]
    



viewResult result =
  div [] <| List.map viewTest result 

viewTest (value, shift, success) =
  p [ class <| if success then "green" else "red" ] [ text <| toString value, text <| toString shift]

validate fun =
  let test = validateIndexes fun in
  [ test ['A', 'B', 'C' ] 0 [0, 1, 2]
  , test ['A', 'B', 'C' ] 1 [1, 2, 0]
  , test ['A', 'B', 'C' ] 2 [2, 0, 1]
  ]

validateIndexedLetter fun =
  let test = validateIndexes fun in
  [ test ['A', 'B', 'C' ] 0 [(0, 'A'), (1, 'B'), (2, 'C')]
  , test ['A', 'B', 'C' ] 1 [(1, 'A'), (2, 'B'), (0, 'C')] ]

validateReversed fun =
  let test = validateIndexes fun in
  [ test ['A', 'B', 'C' ] 0 [('A', 0), ('B', 1), ('C', 2)]
  , test ['A', 'B', 'C' ] 1 [('A', 1), ('B', 2), ('C', 0)] ]

validateCipher fun =
  let test = validateIndexes fun in
  [ test "TEST" 0 "TEST"
  , test "TEST" 1 "UFTU"
  , test "TEST" 3 "WHVW"
  , test "TEST" 14 "HSGH"
  , test "ELM IS GREAT" 3 "HOP LV JUHDW"
  , test "Did you remember about capitalisation" 3 "GLG BRX UHPHPEHU DERXW FDSLWDOLVDWLRQ"
  , test "What ab_ut $$$ and 0.0'" 3 "ZKDW DE_XW $$$ DQG 0.0'"
  ]

validateIndexes fun values base expected = 
  (values, base, fun values base == expected)


letters = [ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' ]


appendIndex values key =
  shiftedIndex values key
  |> pairs values

indexList values key =
  pairs (shiftedIndex values key) values 

-- pairs lefts rights =
--     List.map2 (,) lefts rights

pairs lefts rights =
    List.map2 (\a b -> (a, b)) lefts rights

shiftedIndex list key =
  let 
    len = List.length list
  in
    len - 1 
    |> List.range 0 
    |> List.map (\v -> (v + key) % len)




translateLetter char shiftedDict baseDict =
  let
    lookedup = Dict.get char shiftedDict
    reverseLookup val =
      case val of
        Nothing ->
          Just char
        Just code ->
          Dict.get code baseDict
  in
    lookedup 
    |> reverseLookup
    |> Maybe.withDefault '_'
   

encode val key =
  let 
    shiftedDict = Dict.fromList <| appendIndex letters key
    baseDict = Dict.fromList <| indexList letters 0
  in
    val |> String.toUpper 
    |> String.map (\n -> translateLetter n shiftedDict baseDict)  








  
