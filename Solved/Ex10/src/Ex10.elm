port module Ex10 exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Http
import Json.Decode as Decode

port notifyJs : String -> Cmd msg

port notifiedByJs : (String -> msg) -> Sub msg

main =
    Browser.element
        { init = initial
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


initial: Flags -> (Model, Cmd msg)
initial flags =
    ( Model (User flags.name flags.email defaultNotes) Nothing, Cmd.none )


defaultNotes =
        [ TextNote { id = 1, header = "Header", text = "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful." }
        , ImageNote { id = 2, url = "https://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif" }
        , TextNote { id = 3, header = "I like trains!", text = "Choo choo!" }
        ]

type alias Flags =
    { email : String
    , name : String
    }

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


type alias NoteData a =
    { a
        | id : Int
    }


type alias ImageData =
    NoteData
        { url : String
        }


type alias TextData =
    NoteData
        { header : String
        , text : String
        }


type Msg
    = Open
    | Add
    | UpdateForm FormChange
    | RequestMoreSharks
    | NewImage (Result Http.Error String)
    | NotifiedByJs String


type FormChange
    = Id String
    | Header String
    | Text String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open ->
            ( { model | newNote = Just emptyTextNote }, Cmd.none )

        UpdateForm formValue ->
            ( { model | newNote = updateNote model.newNote formValue }, Cmd.none )

        Add ->
            ( { model | user = addNote model.user model.newNote, newNote = Nothing }, Cmd.none )

        RequestMoreSharks ->
            ( model, getSharks )

        NewImage (Ok newUrl) ->
            ( { model | user = addImage model.user newUrl }, notifyJs newUrl )

        NewImage (Err _) ->
            ( model, Cmd.none )

        NotifiedByJs value ->
            ( model, notifyJs value)


updateNote form formValue =
    Maybe.map
        (\value ->
            case formValue of
                Header textValue ->
                    { value | header = textValue }

                Id textValue ->
                    let
                        converted =
                            String.toInt textValue |> Maybe.withDefault 0
                    in
                    { value | id = converted }

                Text textValue ->
                    { value | text = textValue }
        )
        form


addNote user form =
    case form of
        Just textData ->
            { user | notes = TextNote textData :: user.notes }

        _ ->
            user


getSharks =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=sharks"
    in
    Http.send NewImage (Http.get url decodeUrl)


addImage user url =
    { user | notes = ImageNote { url = url, id = 0 } :: user.notes }


decodeUrl =
    Decode.at [ "data", "image_url" ] Decode.string


emptyTextNote =
    { id = 0, header = "", text = "" }


view model =
    div []
        [ viewPage model
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
                    [ button [ onClick Open, class "btn btn-default" ] [ text "New note" ]
                    , button [ onClick RequestMoreSharks, class "btn btn-default" ] [ text "Add image" ]
                    ]

            Just data ->
                div []
                    [ listNotes [ TextNote data ]
                    , Html.form [ onSubmit Add ]
                        [ input [ class "form-input", type_ "text", placeholder "id", onInput (UpdateForm << Id) ] []
                        , input [ class "form-input", type_ "text", placeholder "header", onInput (UpdateForm << Header) ] []
                        , input [ class "form-input", type_ "text", placeholder "text", onInput (UpdateForm << Text) ] []
                        , button [ onClick Add, class "btn btn-default" ] [ text "Add" ]
                        ]
                    ]
        ]


listNotes notes =
    Keyed.ul [ class "list-group" ] <| List.map viewNote notes


viewNote note =
    case note of
        TextNote data ->
            ( String.fromInt data.id
            , li [ class "list-group-item" ]
                [ viewId data.id
                , h3 [] [ text data.header ]
                , text data.text
                ]
            )

        ImageNote data ->
            ( data.url
            , li [ class "list-group-item" ]
                [ viewId data.id
                , img [ src data.url ] []
                ]
            )


viewId id =
    div [ class "pull-right" ]
        [ text <| String.fromInt id ]


subscriptions model =
    notifiedByJs NotifiedByJs

