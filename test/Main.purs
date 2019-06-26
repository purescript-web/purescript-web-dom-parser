module Test.Main where

import Prelude

import Data.Either (Either, isLeft, isRight)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Test.Data as TD

import Web.DOM.Document (Document)
import Web.DOM.DOMParser (DOMParser, makeDOMParser, parseFromString,
                          parseXMLFromString, _getParserError)

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
  shouldBeRight <- parseNoteDoc domParser
  log $ "is Right? " <> show (isRight shouldBeRight)
  shouldBeLeft <- parseGarbage domParser
  log $ "is Left? " <> show (isLeft shouldBeLeft)

  log "TODO: You should add some tests."
