module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = initial
        , view = view
        , update = update
        }


initial =
    Model defaultUser Nothing


defaultUser =
    User "Dan"
        "elm-workshop@mostlybugless.com"
        [ TextNote { id = 1, header = "Header", text = "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful." }
        , ImageNote { id = 2, url = "https://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif" }
        , TextNote { id = 3, header = "I like trains!", text = "Choo choo!" }
        ]


type alias Model =
    { user : User
    , newNote : Maybe TextData
    }


type alias User =
    { name : String
    , email : String
    , notes : List Note
    }


type Note
    = TextNote TextData
    | ImageNote ImageData


type alias ImageData =
    { id : Int
    , url : String
    }


type alias TextData =
    { id : Int
    , header : String
    , text : String
    }


update : String -> Model -> Model
update msg model =
    case msg of
        "OpenEditor" ->
            { model | newNote = Just { id = 5, header = "Sample header", text = "Sample note text" } }

        "AddNote" ->
            { model
                | newNote = Nothing
                , user = updateUserWithNote model.user model.newNote
            }

        _ ->
            model


updateUserWithNote user editor =
    case editor of
        Nothing ->
            user

        Just textData ->
            { user | notes = TextNote textData :: user.notes }


view : Model -> Html String
view model =
    div []
        [ insertCss
        , insertBootstrap
        , viewPage model
        ]


viewPage model =
    div [ class "container" ]
        [ viewUser model.user
        , viewEditor model.newNote
        ]


viewUser user =
    div [ class "row" ]
        [ h1 [] [ text user.name ]
        , h2 [] [ text user.email ]
        , listNotes user.notes
        ]


viewEditor noteForm =
    div [ class "row" ]
        [ case noteForm of
            Nothing ->
                div []
                    [ button [ class "btn btn-default", onClick "OpenEditor" ] [ text "Add" ]
                    ]

            Just data ->
                div []
                    [ Html.form []
                        [ input [ class "form-input", type_ "text", placeholder "id", value <| String.fromInt data.id ] []
                        , input [ class "form-input", type_ "text", placeholder "header", value data.header ] []
                        , input [ class "form-input", type_ "text", placeholder "text", value data.text ] []
                        , div [ class "btn btn-default", onClick "AddNote" ] [ text "Add" ]
                        ]
                    ]
        ]


listNotes notes =
    ul [ class "list-group" ] <| List.map viewNote notes


viewNote note =
    case note of
        TextNote data ->
            li [ class "list-group-item" ]
                [ viewId data.id
                , h3 [] [ text data.header ]
                , text data.text
                ]

        ImageNote data ->
            li [ class "list-group-item" ]
                [ viewId data.id
                , img [ src data.url ] []
                ]


viewId id =
    div [ class "pull-right" ]
        [ text <| String.fromInt id ]


insertCss =
    Html.node "link" [ rel "stylesheet", href "styles.css" ] []


insertBootstrap =
    Html.node "link" [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" ] []
