module Update exposing (Model, initModel, Msg(..), update, getPosition)

import Time exposing (Time)
import Mouse exposing (Position)
import Window exposing (Size)
import Basics exposing (clamp)
import Navigation
import Array


type alias Model =
    { time : Time
    , iterations : Int
    , distance : Float
    , noise : Float
    , displ : Float
    , rota : Float
    , light : Float
    , color : Float
    , drag : Maybe Drag
    , position : Position
    , window : Size
    }


type alias Drag =
    { start : Position
    , current : Position
    }


initModel : Navigation.Location -> Model
initModel location =
    let
        initVals =
            String.split "," location.hash
                |> Array.fromList
    in
        Model 0 2 8 0.1 0 0 0.5 0 Nothing (Position 0 0) (Size 800 800)


type Msg
    = Frame Time
    | IterationsInput String
    | DistanceInput String
    | NoiseInput String
    | DisplInput String
    | RotaInput String
    | LightInput String
    | ColorInput String
    | DragStart Position
    | DragAt Position
    | DragEnd Position
    | Resize Size
    | MouseWheel Float
    | UrlChange Navigation.Location


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

        DisplInput val ->
            { model | displ = Result.withDefault 0 (String.toFloat val) } ! []

        RotaInput val ->
            { model | rota = Result.withDefault 0 (String.toFloat val) } ! []

        LightInput val ->
            { model | light = Result.withDefault 0 (String.toFloat val) } ! []

        ColorInput val ->
            { model | color = Result.withDefault 0 (String.toFloat val) } ! []

        DragStart xy ->
            { model | drag = (Just (Drag xy xy)), position = (getPosition model) } ! []

        DragAt xy ->
            { model
                | drag = (Maybe.map (\{ start } -> Drag start xy) model.drag)
                , position = (getPosition model)
            }
                ! []

        DragEnd _ ->
            { model | drag = Nothing, position = (getPosition model) } ! []

        Resize size ->
            { model | window = size } ! []

        MouseWheel delta ->
            { model | distance = model.distance + (delta / 10) } ! []

        UrlChange location ->
            model ! []


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (clampY (position.y + current.y - start.y))


clampY : Int -> Int
clampY y =
    clamp -boundY boundY y


boundY : Int
boundY =
    round ((pi / 2.0) * 3000)
