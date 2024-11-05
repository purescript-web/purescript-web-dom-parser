module Test.Main where

import Prelude

import Data.Either (Either, either)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafePartial, unsafeCrashWith)
import Test.Data as TD

import Web.DOM.Document (Document)
import Web.DOM.DOMParser (DOMParser, makeDOMParser, parseFromString, parseXMLFromString, _getParserError)
import Web.DOM.XMLSerializer (makeXMLSerializer, serializeToString)

parseNoteDocRaw :: DOMParser -> Effect Document
parseNoteDocRaw = parseFromString "application/xml" TD.noteXml

parseNoteDoc :: DOMParser -> Effect (Either String Document)
parseNoteDoc = parseXMLFromString TD.noteXml

parseGarbageRaw :: DOMParser -> Effect Document
parseGarbageRaw = parseFromString "application/xml" "<foo>asdf<bar></foo>"

parseGarbage :: DOMParser -> Effect (Either String Document)
parseGarbage = parseXMLFromString "<foo>asdf<bar></foo>"

main :: Effect Unit
main = do
  domParser <- makeDOMParser
  note <- parseNoteDocRaw domParser
  parseNoErrMay <-_getParserError note
  case parseNoErrMay of
    Nothing -> log "no parse error found for garbageOut"
    Just er -> log $ "Error is:" <> er
  log "test0"
  garbageOut <- parseGarbageRaw domParser
  log "test1"
  parseErrMay <-_getParserError garbageOut
  case parseErrMay of
    Nothing -> log "no parse error found for garbageOut"
    Just er -> log $ "Error is:" <> er
  log "test 2"
  shouldBeRight <- either (\_ -> unsafeCrashWith "should be right") identity <$> parseNoteDoc domParser
  either (const unit) (\_ -> unsafeCrashWith "should be left") <$> parseGarbage domParser
  xmlSrlzr <- makeXMLSerializer
  strFromNote <- unsafePartial $ serializeToString shouldBeRight xmlSrlzr
  log $ "serialization of note is:\n" <> strFromNote

  log "TODO: You should add some tests."
