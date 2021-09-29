include Generated_User

let empty = Value.make()

let rootField = ReasonForm.Field.idField("root")
let fields = createFields(rootField, rootField)

let onValidate = (fields: fields<_, Value.t>, form) => {
  open Belt

  let id = form => form
  let values: Value.t = ReasonForm.Form.getValues(form)
  let addError = f => ReasonForm.Form.addError(f.ReasonForm.Field.key)

  let form =
    form
    |> switch values.lastname {
    | None
    | Some("") =>
      addError(fields.lastname, "Lastname is required.")
    | _ => id
    }
    |> switch values.firstname {
    | None
    | Some("") =>
      addError(fields.firstname, "Firstname is required.")
    | _ => id
    }
    |> switch values.username {
    | None
    | Some("") =>
      addError(fields.username, "Username is required.")
    | Some("maarek") => addError(fields.username, "Username is already used.")
    | _ => id
    }
    |> switch values.age {
    | a if a < 18 => addError(fields.age, "You must be major.")
    | _ => id
    }

  let form =
    List.size(values.addresses) < 1
      ? addError(fields.addresses->fst, "Must contains one address at least.", form)
      : form

  let form = form |> Address.validateOptional(fields.mainAddress)

  let form =
    List.mapWithIndex(values.addresses, (i, a) => (i, a)) |> List.reduce(_, form, (form, (i, _)) =>
      form |> Address.validate(fields.addresses->snd(i))
    )

  let form = List.mapWithIndex(values.tags, (i, a) => (i, a)) |> List.reduce(_, form, (
    form,
    (i, tag),
  ) =>
    form |> switch tag {
    | "" => addError(fields.tags->snd(i), "Tag is required.")
    | "forbidden" => addError(fields.tags->snd(i), "Forbidden tag.")
    | _ => id
    }
  )

  let form =
    values.metadata
    ->Belt.Map.String.toList
    ->Belt.List.reduce(form, (form, (key, _)) =>
      form |> Metadata.validate(fields.metadata->snd(key))
    )

  form
}

let initializeForm = initialValues =>
  ReasonForm.Form.initializeForm(~initialValues, ~onValidate=onValidate(fields), ())

let useForm = initialValues => {
  let (wrap, _) = React.useState(() => {
    let form = initializeForm(initialValues)

    (ReasonForm.Wrap.make(form), fields)
  })

  wrap
}

module Form = {
  open ReasonForm
  module Render = BootstrapRender

  let toText = a => a->Belt.Option.getWithDefault("")
  let fromText = a => Some(a)

  @react.component
  let make = () => {
    let (expanded, setExpanded) = React.useState(() => false)
    let (wrap, fields) = useForm(empty)

    let {Hook.isSubmitting: isSubmitting} = Hook.useFormMeta(wrap)

    React.useMemo2(() =>
      <Render.Form
        wrap
        className="form"
        onSubmit={form => {
          Js.log2("values", Form.getValues(form))
          Js.Promise.make((~resolve, ~reject as _) =>
            Js.Global.setTimeout(() => resolve(. Belt.Result.Error("Error on form")), 3000)->ignore
          )
        }}
        render={<fieldset disabled=isSubmitting>
          <div
            className="card"
            style={ReactDOM.Style.make(
              ~width="600px",
              ~marginLeft="auto",
              ~marginRight="auto",
              ~marginTop="50px",
              (),
            )}>
            <div className="card-body">
              <h1 className="card-title"> {React.string("Hello World")} </h1>
              <Render.Row
                label=`Username`
                wrap
                field=fields.username
                input={<Render.Input wrap type_="text" field=fields.username toText fromText />}
              />
              <div className="row">
                <div className="col-sm-6">
                  <Render.Row
                    label=`Lastname`
                    wrap
                    field=fields.lastname
                    input={<Render.Input wrap type_="text" field=fields.lastname toText fromText />}
                  />
                </div>
                <div className="col-sm-6">
                  <Render.Row
                    label=`Firstname`
                    wrap
                    field=fields.firstname
                    input={<Render.Input
                      wrap type_="text" field=fields.firstname toText fromText
                    />}
                  />
                </div>
              </div>
              <Gender.GenderRow wrap expanded field=fields.gender />
              <Render.Row
                label=`Age`
                wrap
                field=fields.age
                input={<Render.Input
                  wrap
                  field=fields.age
                  type_="text"
                  toText=string_of_int
                  fromText={v =>
                    try int_of_string(v) catch {
                    | _ => 0
                    }}
                />}
              />
              <Render.StringMap
                wrap
                field={fields.metadata->fst}
                label=`Méta-données`
                renderInput={key =>
                  <Metadata.Form wrap fields={fields.metadata->snd(key)} title=key />}
              />
              <Render.List
                wrap
                field={fields.tags->fst}
                label=`Tags`
                onAdd={() => wrap->Wrap.dispatch(Helper.List.push(fields.tags->fst, ""))}
                onRemove={i => wrap->Wrap.dispatch(Helper.List.remove(fields.tags->fst, i))}
                renderInput={index => {
                  let field = fields.tags->snd(index)
                  <Render.Row
                    wrap
                    field
                    label=j`Tag $(index)`
                    input={<Render.Input wrap toText={v => v} fromText={v => v} field />}
                  />
                }}
              />
              <Render.Row
                wrap
                field=fields.mainAddress.self
                label=``
                input={<Address.Form wrap title=`Main Address` fields=fields.mainAddress />}
              />
              <Render.List
                wrap
                field={fields.addresses->fst}
                label=`Addresses`
                onAdd={() =>
                  wrap->Wrap.dispatch(Helper.List.push(fields.addresses->fst, Address.empty))}
                onRemove={i => wrap->Wrap.dispatch(Helper.List.remove(fields.addresses->fst, i))}
                renderInput={index =>
                  <Address.Form
                    wrap title=j`Address $(index)` fields={fields.addresses->snd(index)}
                  />}
              />
              <Render.FormErrors wrap />
            </div>
            <div className="card-footer">
              <Render.SubmitButton wrap text="Submit" submittingText="Submitting..." />
              <Render.ResetButton wrap initialForm=wrap.initial text="Reset" />
              <button
                className="btn btn-xs btn-default"
                onClick={event => {
                  ReactEvent.Synthetic.preventDefault(event)
                  setExpanded(not)
                }}>
                {React.string("Expanded = " ++ (expanded ? "true" : "false"))}
              </button>
            </div>
          </div>
        </fieldset>}
      />
    , (isSubmitting, expanded))
  }
}
