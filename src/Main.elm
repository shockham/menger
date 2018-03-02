module Main exposing (main)

import AnimationFrame
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
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
    | IterationsInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame t ->
            { model | time = model.time + t } ! []

        IterationsInput val ->
            { model | iterations = Result.withDefault 1 (String.toInt val) } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Frame


view : Model -> Html Msg
view model =
    div []
        [ viewCanvas model
        , viewControls model
        ]


viewCanvas : Model -> Html Msg
viewCanvas model =
    WebGL.toHtml
        [ width 600
        , height 600
        , style
            [ ( "display", "inline-block" )
            , ( "width", "50%" )
            ]
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            mesh
            { perspective = perspective
            , time = model.time / 1000
            , iterations = model.iterations
            }
        ]


viewControls : Model -> Html Msg
viewControls model =
    div [ style [ ( "display", "inline-block" ) ] ]
        [ input
            [ type_ "range"
            , A.min "1"
            , A.max "8"
            , A.step "1"
            , value (toString model.iterations)
            , onInput IterationsInput
            ]
            []
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1
