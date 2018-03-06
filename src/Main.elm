module Main exposing (main)

import AnimationFrame
import Update exposing (Model, initModel, Msg(..), update)
import View exposing (view)
import Html exposing (program)
import Mouse


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            AnimationFrame.diffs Frame

        Just _ ->
            Sub.batch
                [ AnimationFrame.diffs Frame
                , Mouse.moves DragAt
                , Mouse.ups DragEnd
                ]
