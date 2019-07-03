module Web.DOM.XMLSerializer
  ( XMLSerializer
  , makeXMLSerializer
  , serializeToString
  ) where

import Effect (Effect)
import Web.DOM.Document (Document)

foreign import data XMLSerializer ∷ Type

-- | Create a new `XMLSerializer`
foreign import makeXMLSerializer ∷ Effect XMLSerializer

-- | The `serializeToString(root)` method must [produce an XML
-- | serialization](https://www.w3.org/TR/DOM-Parsing/#dfn-concept-serialize-xml) of
-- | `root` passing a value of false for the [require well-formed
-- | parameter](https://www.w3.org/TR/DOM-Parsing/#dfn-concept-well-formed), and
-- | return the result.
foreign import serializeToString ∷ Document -> XMLSerializer -> Effect String
