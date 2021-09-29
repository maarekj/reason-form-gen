open Belt

type field =
  | Scalar({name: string, type_: string, default: option<string>})
  | Object({
      name: string,
      type_: string,
      module_: string,
      empty: option<string>,
      default: option<string>,
      option: bool,
    })
  | List({
      name: string,
      type_: string,
      module_: option<string>,
      empty: string,
      default: option<string>,
    })
  | StringMap({
      name: string,
      type_: string,
      module_: string,
      empty: string,
      default: option<string>,
    })

type form = {fields: list<field>}

let formFromXmlAst = (xml: XmlDom.ast) => {
  let eq = (a, b) => a == b
  let getExn = (option, error) => {
    switch option {
    | Some(value) => value
    | None => failwith(error)
    }
  }

  switch xml {
  | {tag: "form"} => {
      let fields =
        xml
        ->XmlDom.getFirstChildElement("fields")
        ->Option.getWithDefault({tag: "fields", attrs: list{}, children: list{}})

      {
        fields: fields.children->List.map(field =>
          switch field {
          | {tag: "Scalar", attrs} =>
            Scalar({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in Scalar must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in Scalar must be defined."),
              default: attrs->List.getAssoc("default", eq),
            })
          | {tag: "Object", attrs} =>
            Object({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in Object must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in Object must be defined."),
              module_: attrs
              ->List.getAssoc("module", eq)
              ->getExn("'module' in Object must be defined."),
              empty: attrs->List.getAssoc("empty", eq),
              default: attrs->List.getAssoc("default", eq),
              option: attrs->List.getAssoc("option", eq)->Option.getWithDefault("false") == "true",
            })
          | {tag: "List", attrs} =>
            List({
              name: attrs->List.getAssoc("name", eq)->getExn("'name' in List must be defined."),
              type_: attrs->List.getAssoc("type", eq)->getExn("'type' in List must be defined."),
              module_: attrs->List.getAssoc("module", eq),
              empty: attrs->List.getAssoc("empty", eq)->getExn("'empty' in List must be defined."),
              default: attrs->List.getAssoc("default", eq),
            })
          | {tag: "StringMap", attrs} =>
            StringMap({
              name: attrs
              ->List.getAssoc("name", eq)
              ->getExn("'name' in StringMap must be defined."),
              type_: attrs
              ->List.getAssoc("type", eq)
              ->getExn("'type' in StringMap must be defined."),
              module_: attrs
              ->List.getAssoc("module", eq)
              ->getExn("'module' in StringMap must be defined."),
              empty: attrs
              ->List.getAssoc("empty", eq)
              ->getExn("'empty' in StringMap must be defined."),
              default: attrs->List.getAssoc("default", eq),
            })
          | _ => failwith("unknown field")
          }
        ),
      }
    }
  | {tag: _} => failwith("the root tag must be <form>")
  }
}
