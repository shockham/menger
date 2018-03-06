module Update exposing (Model, initModel, Msg(..), update, getPosition)

import Time exposing (Time)
import Mouse exposing (Position)


type alias Model =
    { time : Time
    , iterations : Int
    , distance : Float
    , noise : Float
    , displ : Float
    , rota : Float
    , light : Float
    , drag : Maybe Drag
    , position : Position
    }


type alias Drag =
    { start : Position
    , current : Position
    }


initModel : Model
initModel =
    Model 0 1 6 0.1 0 0 0.5 Nothing (Position 0 0)


type Msg
    = Frame Time
    | IterationsInput String
    | DistanceInput String
    | NoiseInput String
    | DisplInput String
    | RotaInput String
    | LightInput String
    | DragStart Position
    | DragAt Position
    | DragEnd Position


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


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)
