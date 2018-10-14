module Solved.Ex3_1 exposing (..)

import Browser
import Html exposing (Html, div, p, text, button)
import Html.Events exposing (onClick)


{-
   1. Run `elm reactor` and navigate to this file.

   Docs:
       - https://guide.elm-lang.org/architecture/
       - http://elm-lang.org/docs/syntax
       - http://package.elm-lang.org/packages/elm-lang/html/latest/Html

   Three pillars of Elm Architecture are:
   - Model  - the state of your app
   - Update - a way to update your state
   - View   - a way to view your state as HTML

   The `main` function glues all pieces together using `Browser.sandbox` (or other types of programs - we will see them later).

   The goal of this simple Hello World program is to display a message in a paragraph, when user clicks the button.

   HINT: See what element are being imported and exposed - read about them in docs regarding `Html` package.

   TODO: Display message in the view function according to the requirements above.

   BONUS: Read about `style` function in docs - try to play with it and make hello world example look better!
-}


main =
    Browser.sandbox
        { init = initModel
        , update = update
        , view = view
        }


-- The model will be a message - string.


type alias Model =
    String



-- Bind empty string to the model


initModel =
    ""



-- The message is just a string


type alias Message =
    String



-- Update function will take the message and the current model and it should produce the updated model, which actually is a new message.
-- However, in this example model argument is not used, because it is too simple.


update message model =
    message



-- Our view will display the button and the current model (message) in paragraph as a text element.


view model =
    div []
        [ button [ onClick "Hello Elm!" ] [ text "Say Hi" ]

        -- TODO: What should be in the body of p ??
        , p [] [ text model ]
        ]
