open Belt

type field =
  | Scalar({
      name: string,
      type_: string,
      safeType: option<string>,
      safeTransform: option<string>,
      default: option<string>,
      deccoKey: option<string>,
    })
  | Object({
      name: string,
      type_: string,
      safeType: option<string>,
      safeTransform: option<string>,
      module_: string,
      empty: option<string>,
      default: option<string>,
      option: bool,
      deccoKey: option<string>,
    })
  | List({
      name: string,
      type_: string,
      safeType: option<string>,
      safeTransform: option<string>,
      module_: option<string>,
      empty: string,
      default: option<string>,
      deccoKey: option<string>,
    })
  | StringMap({
      name: string,
      type_: string,
      safeType: option<string>,
      safeTransform: option<string>,
      module_: string,
      empty: string,
      default: option<string>,
      deccoKey: option<string>,
    })

type form = {
  withSafe: bool,
  withDecco: bool,
  fields: list<field>,
}

let formFromXmlAst = (xml: XmlDom.ast) => {
  let eq = (a, b) => a == b
  let getExn = (option, error) => {
    switch option {
    | Some(value) => value
    | None => failwith(error)
    }
  }

  switch xml {
  | {tag: "form", attrs} => {
      let fields =
        xml
        ->XmlDom.getFirstChildElement("fields")
        ->Option.getWithDefault({tag: "fields", attrs: list{}, children: list{}})

      {
        withSafe: attrs->List.getAssoc("withSafe", eq)->Option.getWithDefault("true") == "true",
        withDecco: attrs->List.getAssoc("withDecco", eq)->Option.getWithDefault("false") == "true",
        fields: fields.children->List.map(field =>
          switch field {
          | {tag: "Scalar", attrs} =>
            Scalar({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in Scalar must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in Scalar must be defined."),
              safeType: attrs->List.getAssoc("safeType", eq),
              safeTransform: attrs->List.getAssoc("safeTransform", eq),
              default: attrs->List.getAssoc("default", eq),
              deccoKey: attrs->List.getAssoc("deccoKey", eq),
            })
          | {tag: "Object", attrs} =>
            Object({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in Object must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in Object must be defined."),
              safeType: attrs->List.getAssoc("safeType", eq),
              safeTransform: attrs->List.getAssoc("safeTransform", eq),
              module_: attrs
              ->List.getAssoc("module", eq)
              ->getExn("'module' in Object must be defined."),
              empty: attrs->List.getAssoc("empty", eq),
              default: attrs->List.getAssoc("default", eq),
              option: attrs->List.getAssoc("option", eq)->Option.getWithDefault("false") == "true",
              deccoKey: attrs->List.getAssoc("deccoKey", eq),
            })
          | {tag: "List", attrs} =>
            List({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in List must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in List must be defined."),
              safeType: attrs->List.getAssoc("safeType", eq),
              safeTransform: attrs->List.getAssoc("safeTransform", eq),
              module_: attrs->List.getAssoc("module", eq),
              empty: attrs->List.getAssoc("empty", eq)->getExn("'empty' in List must be defined."),
              default: attrs->List.getAssoc("default", eq),
              deccoKey: attrs->List.getAssoc("deccoKey", eq),
            })
          | {tag: "StringMap", attrs} =>
            StringMap({
              name: attrs
              ->List.getAssoc("name", eq)
              ->getExn("'name' in StringMap must be defined."),
              type_: attrs
              ->List.getAssoc("type", eq)
              ->getExn("'type' in StringMap must be defined."),
              safeType: attrs->List.getAssoc("safeType", eq),
              safeTransform: attrs->List.getAssoc("safeTransform", eq),
              module_: attrs
              ->List.getAssoc("module", eq)
              ->getExn("'module' in StringMap must be defined."),
              empty: attrs
              ->List.getAssoc("empty", eq)
              ->getExn("'empty' in StringMap must be defined."),
              default: attrs->List.getAssoc("default", eq),
              deccoKey: attrs->List.getAssoc("deccoKey", eq),
            })
          | _ => failwith("unknown field")
          }
        ),
      }
    }
  | {tag: _} => failwith("the root tag must be <form>")
  }
}
