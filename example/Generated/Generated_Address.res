/* Generated file */

module Value = {
  type t = {
    street: string,
    city: string,
    zipcode: option<string>,
  }

  let make = (~street="", ~city="", ~zipcode=?, ()) => {
    street: street,
    city: city,
    zipcode: zipcode,
  }
}

type value = Value.t

module Safe = {
  type t = {
    street: string,
    city: string,
    zipcode: string,
  }

  let fromValue = (value: value): option<t> => {
    try {
      Some({
        street: value.street,
        city: value.city,
        zipcode: value.zipcode->Belt.Option.getExn(_),
      })
    } catch {
    | _ => None
    }
  }

  let fromValueExn = (value: value): t => fromValue(value)->Belt.Option.getExn
}

type safe = Safe.t

type fields<'t, 'self> = {
  self: ReasonForm.Field.t<'t, 'self>,
  street: ReasonForm.Field.t<'t, string>,
  city: ReasonForm.Field.t<'t, string>,
  zipcode: ReasonForm.Field.t<'t, option<string>>,
}

let createFields = (self, baseField) => {
  open ReasonForm.Field
  {
    self: self,
    street: baseField->chain(
      createField(
        ~key="street",
        ~getValue=v => v.Value.street,
        ~setValue=(v, values) => {...values, street: v},
      ),
    ),
    city: baseField->chain(
      createField(
        ~key="city",
        ~getValue=v => v.Value.city,
        ~setValue=(v, values) => {...values, city: v},
      ),
    ),
    zipcode: baseField->chain(
      createField(
        ~key="zipcode",
        ~getValue=v => v.Value.zipcode,
        ~setValue=(v, values) => {...values, zipcode: v},
      ),
    ),
  }
}
