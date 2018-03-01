module Shaders exposing (Uniforms, vertexShader, fragmentShader)

import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)
import Meshes exposing (Vertex)


type alias Uniforms =
    { perspective : Mat4
    , time : Float
    }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        uniform mat4 perspective;

        attribute vec3 position;
        attribute vec3 color;

        varying vec3 vcolor;

        void main () {
            gl_Position = perspective * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;

        uniform float time;

        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }
    |]
