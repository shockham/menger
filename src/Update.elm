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
    , round : Float
    , twist : Float
    , size : Float
    , drag : Maybe Drag
    , position : Position
    , window : Size
    }


type alias Drag =
    { start : Position
    , current : Position
    }


indexDefault : Int -> Float -> Array.Array Float -> Float
indexDefault ind def arr =
    Array.get ind arr
        |> Maybe.withDefault def


initModel : Navigation.Location -> Model
initModel location =
    let
        initVals =
            String.dropLeft 1 location.hash
                |> String.split ","
                |> Array.fromList
                |> Array.map String.toFloat
                |> Array.map (Result.withDefault 0)
    in
        { time = 0
        , iterations = round (indexDefault 0 2 initVals)
        , distance = 12
        , noise = indexDefault 5 0.1 initVals
        , displ = indexDefault 2 0 initVals
        , rota = indexDefault 1 0 initVals
        , light = indexDefault 4 0.5 initVals
        , color = indexDefault 3 0 initVals
        , round = indexDefault 6 0.6 initVals
        , twist = indexDefault 7 0 initVals
        , size = indexDefault 8 1 initVals
        , drag = Nothing
        , position = (Position 0 0)
        , window = (Size 800 800)
        }


type Msg
    = Frame Time
    | IterationsInput String
    | DistanceInput String
    | NoiseInput String
    | DisplInput String
    | RotaInput String
    | LightInput String
    | ColorInput String
    | RoundInput String
    | TwistInput String
    | SizeInput String
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
            { model | iterations = Result.withDefault 1 (String.toInt val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        DistanceInput val ->
            { model | distance = Result.withDefault 1 (String.toFloat val) } ! []

        NoiseInput val ->
            { model | noise = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        DisplInput val ->
            { model | displ = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        RotaInput val ->
            { model | rota = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        LightInput val ->
            { model | light = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        ColorInput val ->
            { model | color = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        RoundInput val ->
            { model | round = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        TwistInput val ->
            { model | twist = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

        SizeInput val ->
            { model | size = Result.withDefault 0 (String.toFloat val) }
                ! [ Navigation.modifyUrl (getHash model) ]

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


getHash : Model -> String
getHash model =
    "#"
        ++ (toString model.iterations)
        ++ ","
        ++ (toString model.rota)
        ++ ","
        ++ (toString model.displ)
        ++ ","
        ++ (toString model.color)
        ++ ","
        ++ (toString model.light)
        ++ ","
        ++ (toString model.noise)
