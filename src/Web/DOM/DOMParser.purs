module Web.DOM.DOMParser
  ( DOMParser
  , makeDOMParser
  , parseFromString
  , parseHTMLFromString
  , parseSVGFromString
  , parseXMLFromString
  , _getParserError
  ) where

import Prelude (($), (<<<), (>>=), bind, join, map, pure, unit)

import Data.Array (head)
import Data.Maybe (Maybe(..), isJust)
import Data.Foldable (find)
import Data.Traversable (sequence)
import Effect (Effect)
import Web.DOM.Document (Document, getElementsByTagNameNS)
import Web.DOM.Element (Element, toNode)
import Web.DOM.HTMLCollection (toArray)
import Web.DOM.Node (childNodes, nodeValue)
import Web.DOM.NodeList (item)

import Unsafe.Coerce (unsafeCoerce)
import Prim.TypeError (QuoteLabel, class Warn)

foreign import data DOMParser ∷ Type

--| Create a new `DOMParser`
foreign import makeDOMParser ∷ Effect DOMParser

--| Parse a string with the first argumet being a string for a doctype
foreign import parseFromString ∷ String → String → DOMParser → Effect Document

--| Convience function to parse HTML from a string, partially applying
--| `parseFromString` with "text/html"
parseHTMLFromString ∷ String → DOMParser → Effect Document
parseHTMLFromString s d =
  parseFromString "text/html" s d

--| Convience function to parse SVG from a string, partially applying
--| `parseFromString` with "image/svg+xml"
parseSVGFromString ∷ String → DOMParser → Effect Document
parseSVGFromString s d =
  parseFromString "image/svg+xml" s d

--| Convience function to parse XML from a string, partially applying
--| `parseFromString` with "application/xml"
parseXMLFromString ∷ String → DOMParser → Effect Document
parseXMLFromString s d =
  parseFromString "application/xml" s d

_getParserError :: Document -> Effect (Maybe String)
_getParserError doc = do
  peSearch <- sequence $ map (\ns -> getPeByNS ns) peNSes
  peEleMay <- pure $ join $ find isJust peSearch
  -- pes <- getElementsByTagName "parsererror" doc
  -- peEleMay <- item 0 pes
  peEleChildrenMay <- (pure $ map (childNodes <<< toNode) peEleMay) >>= sequence
  peEleFstNodeMayMay <- (pure $ map (item 0) peEleChildrenMay) >>= sequence
  -- FIXME: nodeValue should return Effect (Maybe String)
  -- TODO: once that is fixed, can check, and return innerHTML of peEleMay
  -- TODO (implemented here as part of the DOMParser spec) in the Nothing case
  sequence $ map (\x -> nodeValue x) (join peEleFstNodeMayMay)
    where
      getPeByNS :: String -> Effect (Maybe Element)
      getPeByNS ns = do
        peCol <- getElementsByTagNameNS (Just ns) "parsererror" doc
        peEleArr <- toArray peCol
        pure $ head peEleArr

      peNSes = [
        "http://www.w3.org/1999/xhtml"
      , "http://www.mozilla.org/newlayout/xml/parsererror.xml"
      ]

undefined :: forall a. Warn (QuoteLabel "undefined in use") => a
undefined = unsafeCoerce unit
