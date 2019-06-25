module Web.DOM.DOMParser
  ( DOMParser
  , makeDOMParser
  , parseFromString
  , parseHTMLFromString
  , parseSVGFromString
  , parseXMLFromString
  , _getParserError
  ) where

import Prelude (($), (<<<), (>>=), bind, discard, join, map, pure)

import Data.Array (catMaybes, head)
import Data.Maybe (Maybe(..), isJust)
import Data.Foldable (find)
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Console (log, logShow) -- FIXME: DEBUGGING
import Global.Unsafe (unsafeStringify) -- FIXME: DEBUGGING
import Web.DOM.Document (Document, getElementsByTagName, getElementsByTagNameNS)
import Web.DOM.Element (Element, tagName, toNode)
import Web.DOM.HTMLCollection (HTMLCollection, toArray)
import Web.DOM.Node (Node, childNodes, nodeValue, textContent)
import Web.DOM.NodeList (item)

-- import Prim.TypeError (QuoteLabel, class Warn)

foreign import data DOMParser ∷ Type

--| Create a new `DOMParser`
foreign import makeDOMParser ∷ Effect DOMParser

--| Parse a string with the first argumet being a string for a doctype
foreign import parseFromString ∷ String -> String -> DOMParser -> Effect Document

--| Convience function to parse HTML from a string, partially applying
--| `parseFromString` with "text/html"
parseHTMLFromString ∷ String -> DOMParser -> Effect Document
parseHTMLFromString s d =
  parseFromString "text/html" s d

--| Convience function to parse SVG from a string, partially applying
--| `parseFromString` with "image/svg+xml"
parseSVGFromString ∷ String -> DOMParser -> Effect Document
parseSVGFromString s d =
  parseFromString "image/svg+xml" s d

--| Convience function to parse XML from a string, partially applying
--| `parseFromString` with "application/xml"
parseXMLFromString ∷ String -> DOMParser -> Effect Document
parseXMLFromString s d =
  parseFromString "application/xml" s d



_getParserError :: Document -> Effect (Maybe String)
_getParserError doc = do
  peElems :: Array Element <- join $ map toArray $ getElementsByTagName "parsererror" doc
  peEleMay :: Maybe Element <- pure $ head $ peElems
  getText peEleMay
    where
      getText :: Maybe Element -> Effect (Maybe String)
      getText elMay = case map toNode elMay of
        Nothing -> pure $ Nothing
        Just nd -> map Just $ textContent nd
