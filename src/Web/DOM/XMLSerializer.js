/* Web.DOM.XMLSerializer */
"use strict";

export function makeXMLSerializer() {
  return new XMLSerializer();
}

export function serializeToString(doc) {
  return function (xmlSerializer) {
    return function () { // Effect thunk
      return xmlSerializer.serializeToString(doc);
    };
  };
}
