module Main exposing (main)

import AnimationFrame
import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Time exposing (Time)
import WebGL exposing (Mesh, Shader)
import Meshes exposing (Vertex, mesh)
import Shaders exposing (Uniforms, vertexShader, fragmentShader)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = (\model -> AnimationFrame.diffs Basics.identity)
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


type alias Model =
    Time


type alias Msg =
    Time


update : Time -> Model -> ( Model, Cmd Msg )
update elapsed currentTime =
    ( elapsed + currentTime, Cmd.none )


view : Float -> Html msg
view t =
    WebGL.toHtml
        [ width 400
        , height 400
        , style [ ( "display", "block" ) ]
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { perspective = perspective, time = t / 1000 }
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1
