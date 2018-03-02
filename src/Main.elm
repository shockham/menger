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
    ( Model 0 1 1 0.1, Cmd.none )


type alias Model =
    { time : Time
    , iterations : Int
    , distance : Float
    , noise : Float
    }


type Msg
    = Frame Time
    | IterationsInput String
    | DistanceInput String
    | NoiseInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame t ->
            { model | time = model.time + t } ! []

        IterationsInput val ->
            { model | iterations = Result.withDefault 1 (String.toInt val) } ! []

        DistanceInput val ->
            { model | distance = Result.withDefault 1 (String.toFloat val) } ! []

        NoiseInput val ->
            { model | noise = Result.withDefault 0 (String.toFloat val) } ! []


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
            , distance = model.distance
            , noise = model.noise
            }
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1


viewControls : Model -> Html Msg
viewControls model =
    div [ style [ ( "display", "inline-block" ) ] ]
        [ viewIterControl model
        , viewDistControl model
        , viewNoiseControl model
        ]


viewIterControl : Model -> Html Msg
viewIterControl model =
    div []
        [ text "ITER:"
        , input
            [ type_ "range"
            , A.min "1"
            , A.max "8"
            , A.step "1"
            , value (toString model.iterations)
            , onInput IterationsInput
            ]
            []
        ]


viewDistControl : Model -> Html Msg
viewDistControl model =
    div []
        [ text "DIST:"
        , input
            [ type_ "range"
            , A.min "1"
            , A.max "20"
            , value (toString model.distance)
            , onInput DistanceInput
            ]
            []
        ]


viewNoiseControl : Model -> Html Msg
viewNoiseControl model =
    div []
        [ text "NOIS:"
        , input
            [ type_ "range"
            , A.min "0"
            , A.max "1"
            , A.step "0.05"
            , value (toString model.noise)
            , onInput NoiseInput
            ]
            []
        ]
