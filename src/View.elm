module View exposing (view)

import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import WebGL exposing (Mesh, Shader)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Update exposing (Model, Msg(..))
import Shaders exposing (Uniforms, vertexShader, fragmentShader)
import Meshes exposing (Vertex, mesh)


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


viewControlLabel : String -> Html Msg
viewControlLabel t =
    span [ style [ ( "vertical-align", "top" ) ] ] [ text t ]


viewRangeInput : String -> String -> String -> number -> (String -> Msg) -> Html Msg
viewRangeInput mn mx st val msg =
    input
        [ type_ "range"
        , A.min mn
        , A.max mx
        , A.step st
        , value (toString val)
        , onInput msg
        ]
        []


viewIterControl : Model -> Html Msg
viewIterControl model =
    div []
        [ viewControlLabel "ITER "
        , viewRangeInput "1" "8" "1" model.iterations IterationsInput
        ]


viewDistControl : Model -> Html Msg
viewDistControl model =
    div []
        [ viewControlLabel "DIST "
        , viewRangeInput "1" "20" "0.2" model.distance DistanceInput
        ]


viewNoiseControl : Model -> Html Msg
viewNoiseControl model =
    div []
        [ viewControlLabel "NOIS "
        , viewRangeInput "0" "1" "0.05" model.noise NoiseInput
        ]
