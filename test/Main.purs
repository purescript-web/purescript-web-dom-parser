module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Test.Data as TD

import Web.DOM.Document (Document)
import Web.DOM.DOMParser (DOMParser, makeDOMParser, parseXMLFromString,
                          _getParserError)

parseNoteDoc :: DOMParser -> Effect Document
parseNoteDoc = parseXMLFromString TD.noteXml

parseGarbage :: DOMParser -> Effect Document
parseGarbage dp = parseXMLFromString "<foo>asdf<bar></foo>" dp

main :: Effect Unit
main = do
  domParser <- makeDOMParser
  note <- parseNoteDoc domParser
  log "test0"
  garbageOut <- parseGarbage domParser
  log "test1"
  parseErrMay <-_getParserError garbageOut
  case parseErrMay of
    Nothing -> log "no parse error found for garbageOut"
    Just er -> log $ "Error is:" <> er
  log "test 2"
  log "TODO: You should add some tests."
