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
        , subscriptions = subscriptions
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    ( Model 0, Cmd.none )


type alias Model =
    { time : Time }


type Msg
    = Frame Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame t ->
            { model | time = model.time + t } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Frame


view : Model -> Html msg
view model =
    WebGL.toHtml
        [ width 600
        , height 600
        , style [ ( "display", "block" ), ( "width", "50%" ) ]
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { perspective = perspective, time = model.time / 1000 }
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1
