type domParser

@new @module("@xmldom/xmldom") external makeDomParser: unit => domParser = "DOMParser"

@send external parseFromString: (domParser, string) => Dom.document = "parseFromString"

type rec ast = {
  tag: string,
  attrs: list<(string, string)>,
  children: list<ast>,
}

let parse = xml => {
  open Webapi.Dom
  let parser = makeDomParser()
  let document = parser->parseFromString(xml)

  let getAttrs = element =>
    element
    ->Element.attributes
    ->NamedNodeMap.toArray
    ->Belt.List.fromArray
    ->Belt.List.map(tag => {
      (tag->Attr.name, tag->Attr.value)
    })

  let rec handleElement = element => {
    {
      tag: element->Element.tagName,
      attrs: getAttrs(element),
      children: element
      ->Element.childNodes
      ->NodeList.toArray
      ->Belt.List.fromArray
      ->Belt.List.map(Element.ofNode)
      ->Belt.List.keepMap(element => element)
      ->Belt.List.map(handleElement),
    }
  }

  handleElement(document->Document.documentElement)
}

let getFirstChildElement = (ast, tagName) => {
  ast.children->Belt.List.getBy(child => child.tag == tagName)
}
