module Update exposing (Model, initModel, Msg(..), update, getPosition)

import Time exposing (Time)
import Mouse exposing (Position)
import Window exposing (Size)


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


initModel : Model
initModel =
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


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)
