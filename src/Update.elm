module Update exposing (Model, initModel, Msg(..), update)

import Time exposing (Time)
import Mouse exposing (Position)


type alias Model =
    { time : Time
    , iterations : Int
    , distance : Float
    , noise : Float
    , drag : Maybe Drag
    }


type alias Drag =
    { start : Position
    , current : Position
    }


initModel : Model
initModel =
    Model 0 1 6 0.1 Nothing


type Msg
    = Frame Time
    | IterationsInput String
    | DistanceInput String
    | NoiseInput String
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

        DragStart xy ->
            { model | drag = (Just (Drag xy xy)) } ! []

        DragAt xy ->
            { model | drag = (Maybe.map (\{ start } -> Drag start xy) model.drag) } ! []

        DragEnd _ ->
            { model | drag = Nothing } ! []
