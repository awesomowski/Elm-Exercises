module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{-
   3 messages with similar functionality that only affect different field?
   Seems ugly.
   Since union types can hold other union types we can create a hierarchy of messages

   1. Notice how Msg type has changed
   2. Run REPL and create a test type, e.g.
           type Msg = Test String
           Evaluate 'Test' - what is it?
       Function composition operator (<<) lets you glue together functions http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#<<
       Union type constructors are functions!
   3. Extend FormChange message to handle rest of fields just like in previous exercise
      Make sure you fully understand annotations, e.g. (b -> c) -> (a -> b) -> a -> c

-}


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
    | FormUpdated FormChange


type FormChange
    = Header String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Open ->
            { model | newNote = Just emptyTextNote }

        FormUpdated formChange ->
            { model | newNote = updateEditor model.newNote formChange }

        Add ->
            { model
                | user = updateUserWithNewNote model.user model.newNote
                , newNote = Nothing
            }


updateEditor form formChange =
    Maybe.map
        (\value ->
            case formChange of
                Header textValue ->
                    { value | header = textValue }
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
                        [ input [ class "form-input", type_ "text", placeholder "id" ] []
                        , input [ class "form-input", type_ "text", placeholder "header", onInput (FormUpdated << Header) ] []
                        , input [ class "form-input", type_ "text", placeholder "text" ] []
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
