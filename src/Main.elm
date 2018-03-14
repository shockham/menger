module Main exposing (main)

import AnimationFrame
import Update exposing (Model, initModel, Msg(..), update)
import View exposing (view)
import Mouse
import Window
import Task
import Navigation


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initModel location, Task.perform Resize Window.size )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.batch
                [ AnimationFrame.diffs Frame
                , Window.resizes Resize
                ]

        Just _ ->
            Sub.batch
                [ AnimationFrame.diffs Frame
                , Window.resizes Resize
                , Mouse.moves DragAt
                , Mouse.ups DragEnd
                ]
