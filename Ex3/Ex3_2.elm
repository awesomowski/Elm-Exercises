module Ex3_2 exposing (..)

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
    {}



-- TODO 2.
-- Discriminated union representing the Msg type should also have `Decrement` case


type Msg
    = Increment



-- TODO 3.
-- Model is no longer an empty record - update initModel accordingly!


initModel : Model
initModel =
    Model



-- TODO 4.
-- update function needs to return new model based on the message
-- case expression might be useful and see records update syntax


update : Msg -> Model -> Model
update msg model =
    model



-- TODO 5.
-- view function takes model and should display current counter value and buttons
-- useful stuff: div, button, text, onClick attribute, toString function (you can always experiment with it in REPL! :)
-- Try to style all elements to make it look a bit nicer!


view : Model -> Html Msg
view model =
    div [] [ text "Success!" ]
