include Generated_Address

let empty = Value.make()

let validateValue = (address: Value.t, fields: fields<_, _>, form) => {
  let addError = f => ReasonForm.Form.addError(f.ReasonForm.Field.key)
  let id = form => form
  form
  |> switch address.street {
  | "" => addError(fields.street, "Street is required.")
  | "forbidden" => addError(fields.street, "Forbidden street.")
  | _ => id
  }
  |> switch address.city {
  | "" => addError(fields.city, "City is required.")
  | "forbidden" => addError(fields.city, "Forbidden city.")
  | _ => id
  }
}

let validate = (fields: fields<_, Value.t>, form) => {
  let address = fields.self.getValue(ReasonForm.Form.getValues(form))
  validateValue(address, fields, form)
}

let validateOptional = (fields: fields<_, option<Value.t>>, form) =>
  switch fields.self.getValue(ReasonForm.Form.getValues(form)) {
  | None => form
  | Some(address) => validateValue(address, fields, form)
  }

module Form = {
  module Render = ReasonForm.BootstrapRender

  let optionToText = a => a->Belt.Option.getWithDefault("")
  let optionFromText = a => Some(a)

  @react.component
  let make = (~wrap, ~fields: fields<_>, ~title=?) =>
    <div className="card">
      <div className="card-body">
        {switch title {
        | Some(title) => <h5 className="card-title"> {React.string(title)} </h5>
        | None => React.null
        }}
        <div className="row">
          <div className="col-sm-12">
            <Render.Row
              label=`Street`
              wrap
              field=fields.street
              input={<Render.Input
                wrap type_="text" field=fields.street toText={v => v} fromText={v => v}
              />}
            />
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <Render.Row
              label=`City`
              wrap
              field=fields.city
              input={<Render.Input
                wrap type_="text" field=fields.city toText={v => v} fromText={v => v}
              />}
            />
          </div>
          <div className="col-sm-6">
            <Render.Row
              label=`Zipcode`
              wrap
              field=fields.zipcode
              input={<Render.Input
                wrap type_="text" field=fields.zipcode toText=optionToText fromText=optionFromText
              />}
            />
          </div>
        </div>
      </div>
    </div>
}
