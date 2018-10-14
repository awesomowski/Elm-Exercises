module SharksTests exposing (..)

import Html
import Html.Attributes
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text, class)
import Test.Html.Event as Event
import Ex10


{-
   Let's play with Elm UI tests!
   In order to run tests, please, call in command-line:
   elm-test

   Below you will find additional exercises for writing your own UI tests!
   Useful docs:
   - https://package.elm-lang.org/packages/elm-explorations/test/latest/
-}


suite : Test
suite =
    describe "Sharks UI Tests"
        [ describe "DOM Structure Tests"
            [ test "User name is displayed properly" <|
                \_ ->
                    Ex10.initial
                        |> Tuple.first
                        |> Ex10.view
                        |> Query.fromHtml
                        |> Query.find [ tag "h1" ]
                        |> Query.contains [ Html.text "Dan" ]

            -- TODO 1.
            -- Write a test which checks user email
            ]
        , describe "User Interactions Tests"
            [ test "By default there is no New form on the page" <|
                \_ ->
                    Ex10.initial
                        |> Tuple.first
                        |> Ex10.view
                        |> Query.fromHtml
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
            , test "When user clicks `New note`, proper message should be sent" <|
                \_ ->
                    Ex10.initial
                        |> Tuple.first
                        |> Ex10.view
                        |> Query.fromHtml
                        |> Query.findAll [ tag "button" ]
                        |> Query.first
                        |> Event.simulate Event.click
                        |> Event.expect Ex10.Open
            , test "When `Open` msg is sent, the form opens" <|
                \_ ->
                    Ex10.initial
                        |> Tuple.first
                        |> Ex10.update Ex10.Open
                        |> Tuple.first
                        |> .newNote
                        |> Expect.equal (Just Ex10.emptyTextNote)

            -- TODO 2.
            -- Write a test which checks that new img tag with src attribute is added when user clicks `Add image`
            ]
        , describe "Fuzzy UI Tests"
            [ fuzz3 int string string "Given three random strings in the New note form, When Add msg is sent, Then new note is on the notes list" <|
                \id_ header body ->
                    Ex10.Model Ex10.defaultUser (Just <| { id = id_, header = header, text = body })
                        |> Ex10.update Ex10.Add
                        |> Tuple.first
                        |> Ex10.view
                        |> Query.fromHtml
                        |> Query.findAll [ tag "li", class "list-group-item" ]
                        |> Query.first
                        |> Query.contains
                            [ Html.div [ Html.Attributes.class "pull-right" ] [ Html.text (toString id_) ]
                            , Html.h3 [] [ Html.text header ]
                            , Html.text body
                            ]
            ]
        ]
