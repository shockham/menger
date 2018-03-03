module Main exposing (main)

import AnimationFrame
import Update exposing (..)
import View exposing (view)
import Html exposing (program)


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
    ( Model 0 1 6 0.1, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Frame
