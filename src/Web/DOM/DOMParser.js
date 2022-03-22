/* Web.DOM.DOMParser */
export function makeDOMParser() {
  return new DOMParser();
}

export function parseFromString(documentType) {
  return function (sourceString) {
    return function (domParser) {
      return function () { // Effect thunk
        return domParser.parseFromString(sourceString, documentType);
      };
    };
  };
}
