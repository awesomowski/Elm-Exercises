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


type Msg
    = Open
    | Add
    | UpdateHeader String
    | UpdateId String
    | UpdateText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Open ->
            { model | newNote = Just emptyTextNote }

        UpdateHeader value ->
            { model | newNote = updateEditor model.newNote msg }

        UpdateId value ->
            { model | newNote = updateEditor model.newNote msg }

        UpdateText value ->
            { model | newNote = updateEditor model.newNote msg }

        Add ->
            { model
                | user = updateUserWithNewNote model.user model.newNote
                , newNote = Nothing
            }


updateEditor form msg =
    Maybe.map
        (\value ->
            case msg of
                UpdateHeader textValue ->
                    { value | header = textValue }

                UpdateId textValue ->
                    let
                        converted =
                            String.toInt textValue |> Maybe.withDefault 0
                    in
                    { value | id = converted }

                UpdateText textValue ->
                    { value | text = textValue }

                _ ->
                    value
        )
        form


updateUserWithNewNote user form =
    case form of
        Just textData ->
            { user | notes = TextNote textData :: user.notes }

        _ ->
            user


emptyTextNote =
    { id = 0, header = "", text = "" }


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
                    [ button [ onClick Open, class "btn btn-default" ] [ text "Add" ]
                    ]

            Just data ->
                div []
                    [ listNotes [ TextNote data ]
                    , Html.form [ onSubmit Add ]
                        [ input [ class "form-input", type_ "text", placeholder "id", onInput UpdateId ] []
                        , input [ class "form-input", type_ "text", placeholder "header", onInput UpdateHeader ] []
                        , input [ class "form-input", type_ "text", placeholder "text", onInput UpdateText ] []
                        , div [ onClick Add, class "btn btn-default" ] [ text "Add" ]
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
