module Transduction.List exposing (stepper, concat, transduce)

{-| A stepper function for use with `Transducer`s like `concat`.

@docs stepper, concat, transduce

-}

import Transduction as Trans
    exposing
        ( Reducer
        , Reply(Continue, Halt)
        , Transducer
        , fold
        , compose
        , mapInput
        )


{-| Reduce elements of a `List` in order.
-}
stepper : Reducer input output -> List input -> Reply input output
stepper reducer xs =
    case xs of
        [] ->
            Continue reducer

        x :: rest ->
            case Trans.reduce reducer x of
                Halt output ->
                    Halt output

                Continue nextReducer ->
                    stepper nextReducer rest


{-| A special concat just for `List`s.
-}
concat : Transducer input output (List input) output
concat =
    Trans.concat stepper


{-| Run the transducer against a `List` of inputs.
-}
transduce : Transducer afterInput (Maybe afterInput) thisInput thisOutput -> List thisInput -> thisOutput
transduce transducer xs =
    Trans.transduce (concat |> compose transducer) xs
