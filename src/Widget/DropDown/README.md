# elm-html-widgets

Reusable widgets for elm-html

[![](https://travis-ci.org/NoRedInk/elm-html-widgets.svg?branch=master)](https://travis-ci.org/NoRedInk/elm-html-widgets)

---
[![NoRedInk](https://cloud.githubusercontent.com/assets/1094080/9069346/99522418-3a9d-11e5-8175-1c2bfd7a2ffe.png)][team]
[team]: http://noredink.com/about/team

# Development

```
elm package install
npm install
```

# Testsuite

```
npm test
```

# Example Usage Accordion:

```
    type Action
        = NoOp
        | SetExpanded Int Bool

    -- You could keep track of `expanded` in a separate data structure, if that
    -- were desirable, by supplying an appropriate `setExpanded` and
    -- `getExpanded` for the `Accordion`, and an appropriate `update` method
    type alias Entry =
        { id : Int
        , title : String
        , synopsis : String
        , expanded : Bool
        }

    sampleEntry : Entry
    sampleEntry =
        { id = 1
        , title = "Walden"
        , synopsis = "A student is bitten by a radioactive spider..."
        , expanded = True
        }

    update : Action -> List Entry -> List Entry
    update action model =
        case action of
            NoOp ->
                model

            SetExpanded id expanded ->
                List.map (\entry ->
                    if entry.id == id
                        then { entry | expanded <- expanded }
                        else entry
                ) model

    accordion : Signal.Address Action -> Accordion Entry
    accordion address =
        { viewHeader = .title >> Html.text
        , viewPanel = .synopsis >> Html.text
        , setExpanded = \expanded {id} -> Signal.message address (SetExpanded id expanded)
        , getExpanded = .expanded
        }

    view : Signal.Address Action -> List Entry -> Html
    view address model =
        Accordion.view (accordion address) model
