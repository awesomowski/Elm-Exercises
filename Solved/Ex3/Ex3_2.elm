module Ex3.Ex3_2 exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


{-

   Docs:
    - http://elm-lang.org/docs/syntax
    - http://package.elm-lang.org/packages/elm-lang/html/latest/Html

   In this exercise, two-directional counter will be implemented.
   The initial state of the counter is 0.
   When user clicks `+1` button, the number will be incremented.
   When user clicks `-1` button, the number will be decremented.

   You will find TODOs below.

   BONUS: Try to change the color of the counter to green when it is positive, blue when equals 0, and red when is negative.
   BONUS 2: Add a Reset button
-}


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }



-- TODO 1.
-- Model should be the record with `counter` property of type `Int`


type alias Model =
    { counter : Int
    }



-- TODO 2.
-- Discriminated union representing the Msg type should also have `Decrement` case


type Msg
    = Increment
    | Decrement
    | Reset



-- TODO 3.
-- Model is no longer an empty record - update initModel accordingly!


initModel : Model
initModel =
    Model 0



-- TODO 4.
-- update function needs to return new model based on the message
-- case expression might be useful and see records update syntax


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1 }

        Decrement ->
            { model | counter = model.counter - 1 }

        Reset ->
            { model | counter = 0 }



-- TODO 5.
-- view function takes model and should display current counter value and buttons
-- useful stuff: div, button, text, onClick attribute, toString function (you can always experiment with it in REPL! :)
-- Try to style all elements to make it look a bit nicer!


view : Model -> Html Msg
view model =
    div [ centered, bold ]
        [ button [ onClick Increment ] [ text "+1" ]
        , div
            [ margin20, getCounterColorStyle model ]
            [ text (String.fromInt model.counter) ]
        , button [ onClick Decrement ] [ text "-1" ]
        , Html.node "br" [] []
        , button [ onClick Reset ] [ text "Reset" ]
        ]


centered =
    style "text-align" "center"


margin20 =
    style "margin" "20px"


bold =
    style "font-weight" "bold"


getCounterColorStyle : Model -> Html.Attribute msg
getCounterColorStyle model =
    let
        color =
            if model.counter < 0 then
                "red"
            else if model.counter == 0 then
                "blue"
            else
                "green"
    in
        style "color" color
