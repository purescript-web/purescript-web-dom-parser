module Web.DOM.DOMParser
  ( DOMParser
  , makeDOMParser
  , parseFromString
  , parseHTMLFromString
  , parseSVGFromString
  , parseXMLFromString
  , _getParserError
  ) where

import Prelude (($), bind, join, map, pure)

import Data.Array (head)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Web.DOM.Document (Document, getElementsByTagName)
import Web.DOM.Element (Element, toNode)
import Web.DOM.ElementName (ElementName(..))
import Web.DOM.HTMLCollection (toArray)
import Web.DOM.Node (textContent)

foreign import data DOMParser ∷ Type

-- | Create a new `DOMParser`
foreign import makeDOMParser ∷ Effect DOMParser

-- | Parse a string with the first argumet being a string for a doctype.
-- | Does not capture errors; consider using other wrapper functions,
-- | e.g. `parseXMLFromString`.
foreign import parseFromString ∷ String -> String -> DOMParser -> Effect Document

-- | Convenience function to parse HTML from a string, partially applying
-- | `parseFromString` with "text/html"
parseHTMLFromString ∷ String -> DOMParser -> Effect (Either String Document)
parseHTMLFromString s d = do
  doc <- parseFromString "text/html" s d
  errMay <- _getParserError doc
  pure $ returnIfNothing errMay doc

-- | Convenience function to parse SVG from a string, partially applying
-- | `parseFromString` with "image/svg+xml"
parseSVGFromString ∷ String -> DOMParser -> Effect (Either String Document)
parseSVGFromString s d = do
  doc <- parseFromString "image/svg+xml" s d
  errMay <- _getParserError doc
  pure $ returnIfNothing errMay doc

-- | Convenience function to parse XML from a string, partially applying
-- | `parseFromString` with "application/xml"
parseXMLFromString ∷ String -> DOMParser -> Effect (Either String Document)
parseXMLFromString s d = do
  doc <- parseFromString "application/xml" s d
  errMay <- _getParserError doc
  pure $ returnIfNothing errMay doc

-- | Utility method for extracting Dom Parser errors from document;
-- | should only need to be used if calling `parseFromString` directly.
_getParserError :: Document -> Effect (Maybe String)
_getParserError doc = do
  peElems :: Array Element <- join $ map toArray $ getElementsByTagName (ElementName "parsererror") doc
  peEleMay :: Maybe Element <- pure $ head $ peElems
  getText peEleMay
    where
      getText :: Maybe Element -> Effect (Maybe String)
      getText elMay = case map toNode elMay of
        Nothing -> pure $ Nothing
        Just nd -> map Just $ textContent nd

-- | Like [Data.Either.note](https://pursuit.purescript.org/packages/purescript-either/docs/Data.Either#v:note),
-- | but with the logic reversed. Used internally for converting the
-- | result of `_getParserError` to an `Either`.
returnIfNothing :: forall a b. Maybe a -> b -> Either a b
returnIfNothing errMay val = case errMay of
  Nothing -> Right val
  Just er -> Left er
