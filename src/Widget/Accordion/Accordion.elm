module Widget.Accordion (Accordion, view, originalView) where


import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, classList, attribute)
import Html.Events exposing (on)
import Signal exposing (Message)
import Json.Decode

type alias Accordion entry =
    { viewHeader : entry -> Html
    , viewPanel : entry -> Html
    , setExpanded : Bool -> entry -> Message
    , getExpanded : entry -> Bool
    }

view : Accordion entry -> List entry -> Html
view accordion entries =
    let
        viewEntry entry =
            let
                expanded =
                    accordion.getExpanded entry

                entryClass =
                    classList
                        [ "accordion-entry" => True
                        , "accordion-entry-state-expanded" => expanded
                        , "accordion-entry-state-collapsed" => (not expanded)
                        ]

                entryHeader =
                    div
                        [ class "accordion-entry-header"
                        , on
                            "click"
                            (Json.Decode.succeed ())
                            (\_ -> accordion.setExpanded (not expanded) entry)
                        ]
                        [ accordion.viewHeader entry ]

                entryPanel =
                    div
                        [ class "accordion-entry-panel", role "tabpanel" ]
                        [ accordion.viewPanel entry ]
            in
                div
                    [ entryClass, role "tab" ]
                    [ entryHeader, entryPanel ]
    in
        div
            [ class "accordion"
            , role "tablist"
            , attribute "aria-live" "polite"
            ]
            (List.map viewEntry entries)


{- Convenience for making tuples. Looks nicer in conjunction with classList. -}
(=>) : a -> b -> (a, b)
(=>) =
    (,)


{- Convenience for defining role attributes, e.g. <div role="tabpanel"> -}
role : String -> Attribute
role =
    attribute "role"


{-| An implementation of the original API, for easy transition to the new API.
-}
originalView :
    (entry -> Html) ->
    (entry -> Html) ->
    (Bool -> entry -> Message) ->
    List (entry, Bool) -> Html
originalView viewHeader viewPanel setExpanded list =
    let
        accordion =
            { viewHeader = viewHeader << fst
            , viewPanel = viewPanel << fst
            , setExpanded = \expanded entry -> setExpanded expanded (fst entry)
            , getExpanded = snd
            }

    in
        view accordion list
