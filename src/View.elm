module View exposing (view)

import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import WebGL exposing (Mesh, Shader)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 exposing (vec2)
import Update exposing (Model, Msg(..), getPosition)
import Shaders exposing (Uniforms, vertexShader, fragmentShader)
import Meshes exposing (Vertex, mesh)
import Mouse exposing (position, Position)
import Json.Decode as Decode


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewCanvas model
        , viewControls model
        ]


viewCanvas : Model -> Html Msg
viewCanvas model =
    WebGL.toHtml
        [ class "canvas"
        , width model.window.width
        , height model.window.height
        , on "mousedown" (Decode.map DragStart Mouse.position)
        , on "wheel" (Decode.map MouseWheel (Decode.field "deltaY" Decode.float))
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
            , displ = model.displ
            , rota = model.rota
            , light = model.light
            , ncolor = model.color
            , round = model.round
            , twist = model.twist
            , mouse_pos = vec2 (toFloat model.position.x) (toFloat model.position.y)
            , dimensions = vec2 (toFloat model.window.width) (toFloat model.window.height)
            }
        ]


perspective : Mat4
perspective =
    Mat4.makeOrtho2D 0 1 0 1


viewControls : Model -> Html Msg
viewControls model =
    div
        [ class "control-container" ]
        [ div [] [ text "SHAPE" ]
        , viewIterControl model
        , viewRotaControl model
        , viewDisplControl model
        , viewRoundControl model
        , viewTwistControl model
        , div [] [ text "COLOURS" ]
        , viewColorControl model
        , viewLightControl model
        , viewNoiseControl model
        ]


viewControlLabel : String -> Html Msg
viewControlLabel t =
    span [ class "control-label" ] [ text t ]


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
        [ viewControlLabel "ITERATIONS"
        , viewRangeInput "0" "8" "1" model.iterations IterationsInput
        ]


viewNoiseControl : Model -> Html Msg
viewNoiseControl model =
    div []
        [ viewControlLabel "NOISE"
        , viewRangeInput "0" "1" "0.05" model.noise NoiseInput
        ]


viewDisplControl : Model -> Html Msg
viewDisplControl model =
    div []
        [ viewControlLabel "DISPLACE"
        , viewRangeInput "0" "5" "0.05" model.displ DisplInput
        ]


viewRotaControl : Model -> Html Msg
viewRotaControl model =
    div []
        [ viewControlLabel "ROTATION"
        , viewRangeInput "0" "2" "0.05" model.rota RotaInput
        ]


viewLightControl : Model -> Html Msg
viewLightControl model =
    div []
        [ viewControlLabel "LIGHT"
        , viewRangeInput "0" "1" "0.05" model.light LightInput
        ]


viewColorControl : Model -> Html Msg
viewColorControl model =
    div []
        [ viewControlLabel "COLOUR"
        , viewRangeInput "0" "1" "0.05" model.color ColorInput
        ]


viewRoundControl : Model -> Html Msg
viewRoundControl model =
    div []
        [ viewControlLabel "ROUND"
        , viewRangeInput "0" "2" "0.05" model.round RoundInput
        ]


viewTwistControl : Model -> Html Msg
viewTwistControl model =
    div []
        [ viewControlLabel "TWIST"
        , viewRangeInput "0" "10" "0.5" model.twist TwistInput
        ]
