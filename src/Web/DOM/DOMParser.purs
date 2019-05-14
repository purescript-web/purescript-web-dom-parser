module Web.DOM.DOMParser
  ( DOMParser
  , makeDOMParser
  , parseFromString
  , parseHTMLFromString
  , parseSVGFromString
  , parseXMLFromString
  , _getParserError
  ) where

import Prelude (($), (<<<), (>>=), bind, join, map, pure)

import Data.Maybe (Maybe)
import Data.Traversable (sequence)
import Effect (Effect)
import Web.DOM.Document (Document, getElementsByTagName)
import Web.DOM.Element (toNode)
import Web.DOM.HTMLCollection (item)
import Web.DOM.Node (childNodes, nodeValue)
import Web.DOM.NodeList as NL

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
  pes <- getElementsByTagName "parsererror" doc
  peEleMay <- item 0 pes
  peEleChildrenMay <- (pure $ map (childNodes <<< toNode) peEleMay) >>= sequence
  peEleFstNodeMayMay <- (pure $ map (NL.item 0) peEleChildrenMay) >>= sequence
  sequence $ map (\x -> nodeValue x) (join peEleFstNodeMayMay)

-- ffNs = "http://www.mozilla.org/newlayout/xml/parsererror.xml"
