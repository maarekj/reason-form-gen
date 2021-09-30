open Belt

let rec join = (list, sep) => {
  switch list {
  | list{} => ""
  | list{str, ...list} => str ++ sep ++ join(list, sep)
  }
}

let generateForm = (file: string, form: Config.form) => {
  let getNameFromField = (field: Config.field) => {
    switch field {
    | Object({name})
    | List({name})
    | StringMap({name})
    | Scalar({name}) => name
    }
  }
  let getDefaultFromField = (field: Config.field) => {
    switch field {
    | Object({default})
    | List({default})
    | StringMap({default})
    | Scalar({default}) => default
    }
  }

  let generateModuleValue = () => {
    `module Value = {
    type t = {
${form.fields
      ->List.map(field => {
        switch field {
        | Object({name, type_, option: false}) => `${name}: ${type_}`
        | Object({name, type_, option: true}) => `${name}: option<${type_}>`
        | List({name, type_}) => `${name}: list<${type_}>`
        | StringMap({name, type_}) => `${name}: Belt.Map.String.t<${type_}>`
        | Scalar({name, type_}) => `${name}: ${type_}`
        }
      })
      ->join(",\n")}
    }

    let make = (
${form.fields
      ->List.map(field => {
        switch (getDefaultFromField(field), getNameFromField(field)) {
        | (None, name) => `~${name}`
        | (Some(default), name) => `~${name}=${default}`
        }
      })
      ->join(",\n")}
        (),
    ) => {

${form.fields
      ->List.map(field => {
        `        ${getNameFromField(field)}: ${getNameFromField(field)}`
      })
      ->join(",\n")}
    }
}

type value = Value.t

`
  }

  let generateModuleSafe = () => {
    let hasSafe = form.fields->List.some(field =>
      switch field {
      | Object({safeType: None, safeTransform: None})
      | List({safeType: None, safeTransform: None})
      | StringMap({safeType: None, safeTransform: None})
      | Scalar({safeType: None, safeTransform: None}) => false
      | _ => true
      }
    )

    if hasSafe {
      "
      module Safe = {
        type t = value
        let fromValue = (value: value) : option<t> => Some(value)
        let fromValueExn = fromValue
      }

      type safe = Safe.t
      "
    } else {
      `module Safe = {
      type t = {
      ${form.fields
        ->List.map(field => {
          switch field {
          | Object({name, safeType: Some(safeType)})
          | List({name, safeType: Some(safeType)})
          | StringMap({name, safeType: Some(safeType)})
          | Scalar({name, safeType: Some(safeType)}) =>
            `${name}: ${safeType}`
          | Object({name, safeType: None, type_, option: false}) => `${name}: ${type_}`
          | Object({name, safeType: None, type_, option: true}) => `${name}: option<${type_}>`
          | List({name, safeType: None, type_}) => `${name}: list<${type_}>`
          | StringMap({name, safeType: None, type_}) => `${name}: Belt.Map.String.t<${type_}>`
          | Scalar({name, safeType: None, type_}) => `${name}: ${type_}`
          }
        })
        ->join(",\n")}
      }

      let fromValue = (value: value): option<t> => {
        try {
          Some({${form.fields
        ->List.map(field => {
          switch field {
          | Object({name, safeTransform: Some(transform)})
          | List({name, safeTransform: Some(transform)})
          | StringMap({name, safeTransform: Some(transform)})
          | Scalar({name, safeTransform: Some(transform)}) =>
            `${name}: (value.${name})->${transform}`
          | Object({name, safeTransform: None})
          | List({name, safeTransform: None})
          | StringMap({name, safeTransform: None})
          | Scalar({name, safeTransform: None}) =>
            `${name}: value.${name}`
          }
        })
        ->join(",\n")}
      })
        } catch {
          | _ => None
        }
      }

      let fromValueExn = (value: value): t => fromValue(value)->Belt.Option.getExn
    }
    
    type safe = Safe.t
    `
    }
  }

  let generateFieldsType = () => {
    `type fields<'t, 'self> = {
    self: ReasonForm.Field.t<'t, 'self>,
${form.fields
      ->List.map(field => {
        switch field {
        | Object({name, type_, module_, option: false}) =>
          `    ${name}: ${module_}.fields<'t, ${type_}>`
        | Object({name, type_, module_, option: true}) =>
          `    ${name}: ${module_}.fields<'t, option<${type_}>>`
        | List({name, type_, module_: Some(module_)}) =>
          `    ${name}: (ReasonForm.Field.t<'t, list<${type_}>>, int => ${module_}.fields<'t, ${type_}>)`
        | List({name, type_, module_: None}) =>
          `    ${name}: (ReasonForm.Field.t<'t, list<${type_}>>, int => ReasonForm.Field.t<'t, ${type_}>)`
        | StringMap({name, type_, module_}) =>
          `    ${name}: (ReasonForm.Field.t<'t, Belt.Map.String.t<${type_}>>, string => ${module_}.fields<'t, ${type_}>)`
        | Scalar({name, type_}) => `    ${name}: ReasonForm.Field.t<'t, ${type_}>`
        }
      })
      ->join(",\n")}
}`
  }

  let generateCreateFields = () => {
    `let createFields = (self, baseField) => {
  open ReasonForm.Field
  {
    self: self,
${form.fields
      ->List.map(field => {
        switch field {
        | Object({name, module_, option: false}) =>
          `    ${name}: {
        let field = chain(
            baseField,
            createField(
                ~key="${name}",
                ~getValue=v => v.Value.${name},
                ~setValue=(v, values) => {...values, ${name}: v},
            ),
        )

        ${module_}.createFields(field, field)
      }`
        | Object({empty: None, option: true}) =>
          failwith("error: if object 'option' is given, 'empty' must be given.")
        | Object({name, module_, empty: Some(empty), option: true}) =>
          `    ${name}: {
        let field = chain(
            baseField,
            createField(
                ~key="${name}",
                ~getValue=v => v.Value.${name},
                ~setValue=(v, values) => {...values, ${name}: v},
            ),
        )

        ${module_}.createFields(field, option(field, ${empty}))
      }`
        | List({name, module_: Some(module_), empty}) =>
          `    ${name}: chain(
            baseField,
            createField(
                ~key="${name}",
                ~getValue=v => v.Value.${name},
                ~setValue=(v, values) => {...values, ${name}: v},
            ),
        )->chainList(${empty}, ${module_}.createFields)
      `
        | List({name, module_: None, empty}) =>
          `    ${name}: {
            let field = chain(
            baseField,
            createField(
                ~key="${name}",
                ~getValue=v => v.Value.${name},
                ~setValue=(v, values) => {...values, ${name}: v},
            ),
        )
        (field, makeListItemField(${empty}, field))
      }`
        | StringMap({name, module_, empty}) =>
          `    ${name}: chain(
            baseField,
            createField(
                ~key="${name}",
                ~getValue=v => v.Value.${name},
                ~setValue=(v, values) => {...values, ${name}: v},
            ),
        )->chainStringMap(${empty}, ${module_}.createFields)
      `
        | Scalar({name}) =>
          `    ${name}: baseField->chain(
        createField(
            ~key="${name}",
            ~getValue=v => v.Value.${name},
            ~setValue=(v, values) => {...values, ${name}: v},
        ),
    )`
        }
      })
      ->join(",\n")}
  }
}`
  }

  let content =
    "/* Generated file */\n\n" ++
    generateModuleValue() ++
    "\n\n" ++
    generateModuleSafe() ++
    "\n\n" ++
    generateFieldsType() ++
    "\n\n" ++
    generateCreateFields()

  let dirname = file->Node.Path.dirname
  let basename = file->Node.Path.basename
  let firstPart = basename->Js.String2.split(".")->List.fromArray->List.head

  switch firstPart {
  | None => failwith("firstPart is empty")
  | Some(firstPart) => {
      let outPath = Node.Path.join([dirname, "Generated", "Generated_" ++ firstPart ++ ".res"])
      Node_Fs.mkdirRecurisveSync(Node.Path.join([dirname, "Generated"]), ())->ignore
      Js.log("generate " ++ outPath)
      Node.Fs.writeFileAsUtf8Sync(outPath, content)
    }
  }
}

let generateFiles = files => {
  let rec generateFiles = files => {
    switch files {
    | list{} => ()
    | list{file, ...files} =>
      let content = Node.Fs.readFileAsUtf8Sync(file)
      let xmlAst = XmlDom.parse(content)
      let form = Config.formFromXmlAst(xmlAst)

      generateForm(file, form)
      generateFiles(files)
    }
  }

  generateFiles(files->List.fromArray)
}
