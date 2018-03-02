module Main exposing (main)

import AnimationFrame
import Html exposing (..)
import Html.Attributes as A exposing (..)
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
    ( Model 0 1, Cmd.none )


type alias Model =
    { time : Time
    , iterations : Int
    }


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
    div []
        [ viewCanvas model
        , viewControls model
        ]


viewCanvas : Model -> Html msg
viewCanvas model =
    WebGL.toHtml
        [ width 600
        , height 600
        , style
            [ ( "display", "block" )
            , ( "width", "50%" )
            ]
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { perspective = perspective
            , time = model.time / 1000
            , iterations = 2
            }
        ]


viewControls : Model -> Html msg
viewControls model =
    div []
        [ input
            [ type_ "range"
            , A.min "1"
            , A.max "8"
            , A.step "1"
            , value (toString model.iterations)
            ]
            []
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1
