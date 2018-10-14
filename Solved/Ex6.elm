module Ex6 exposing (..)

import Array exposing (Array)
import Random
import Browser
import Html exposing (Html, div, h1, p, blockquote, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


-- MODEL


type alias Quote =
    { text : String
    , author : String
    }


type alias Model =
    { quote : Maybe Quote
    }


initialModel : Model
initialModel =
    { quote = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, callForRandomQuote secretQuotes )



-- UPDATE


type Msg
    = AskForQuote
    | ReturnQuote (Maybe Quote)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AskForQuote ->
            ( model, callForRandomQuote secretQuotes )

        ReturnQuote quote ->
            ( { model | quote = quote }, Cmd.none )


callForRandomQuote : Array Quote -> Cmd Msg
callForRandomQuote quotes =
    let
        maxValue =
            Array.length secretQuotes - 1

        getNthSecretQuote n =
            Array.get n secretQuotes

        randomQuoteGenerator =
            Random.map getNthSecretQuote <| Random.int 0 maxValue
    in
        Random.generate ReturnQuote randomQuoteGenerator



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "A pinch of Elmspiration..." ]
        , viewQuote model
        , viewButton
        ]


viewQuote : Model -> Html Msg
viewQuote model =
    case model.quote of
        Just quote ->
            let
                quoteText =
                    Maybe.withDefault "" <| Maybe.map .text model.quote

                quoteAuthor =
                    Maybe.withDefault "" <| Maybe.map .author model.quote
            in
                div []
                    [ blockquote blockquoteStyles [ text quoteText ]
                    , div
                        [ style "margin" "1em 4.5em" ]
                        [ text quoteAuthor ]
                    ]

        Nothing ->
            p [ style "margin" "1em 3em" ] [ text "Loading..." ]


viewButton : Html Msg
viewButton =
    button
        ([ onClick AskForQuote
        ] ++ buttonStyles)
        [ text "Inspire me!" ]


subscriptions : Model -> Sub Msg
subscriptions =
    \_ -> Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


secretQuotes : Array Quote
secretQuotes =
    Array.fromList
        [ { text = "Controlling complexity is the essence of computer programming."
          , author = "Brian Kernighan"
          }
        , { text = "First, solve the problem. Then, write the code."
          , author = "John Johnson"
          }
        , { text = "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live."
          , author = "Martin Golding"
          }
        , { text = "In theory, there is no difference between theory and practice. But, in practice, there is."
          , author = "Jan L. A. van de Snepscheut"
          }
        , { text = "Once a new technology starts rolling, if you’re not part of the steamroller, you’re part of the road."
          , author = "Stewart Brand"
          }
        , { text = "You can’t have great software without a great team, and most software teams behave like dysfunctional families."
          , author = "Jim McCarthy"
          }
        , { text = "Programming is not a zero-sum game. Teaching something to a fellow programmer doesn’t take it away from you. I’m happy to share what I can, because I’m in it for the love of programming."
          , author = "John Carmack"
          }
        ]


buttonStyles : List (Html.Attribute msg)
buttonStyles =
    [ style "margin" "0.5em 1em"
    , style "padding" "0.25em 1em"
    , style "background" "#cfcfcf"
    , style "border" "1px solid #6b6b6b"
    , style "font-family" "serif"
    , style "font-weight" "bold"
    ]


blockquoteStyles : List (Html.Attribute msg)
blockquoteStyles =
    [ style "border-left" "0.5em solid #cfcfcf"
    , style "padding" "0.5em"
    , style "font-family" "serif"
    , style "font-style" "italic"
    ]
