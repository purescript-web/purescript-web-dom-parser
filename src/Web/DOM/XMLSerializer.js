/* Web.DOM.XMLSerializer */
"use strict";

exports.makeXMLSerializer = function () {
  return new XMLSerializer();
};

exports.serializeToString =  function (doc) {
  return function (xmlSerializer) {
    return function () { // Effect thunk
      return xmlSerializer.serializeToString(doc);
    };
  };
};
