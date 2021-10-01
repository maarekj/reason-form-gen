/* Generated file */

module Value = {
  type t = {
    title: string,
    desc: string,
  }

  let make = (~title="", ~desc="", ()) => {
    title: title,
    desc: desc,
  }
}

type value = Value.t

type fields<'t, 'self> = {
  self: ReasonForm.Field.t<'t, 'self>,
  title: ReasonForm.Field.t<'t, string>,
  desc: ReasonForm.Field.t<'t, string>,
}

let createFields = (self, baseField) => {
  open ReasonForm.Field
  {
    self: self,
    title: baseField->chain(
      createField(
        ~key="title",
        ~getValue=v => v.Value.title,
        ~setValue=(v, _values) => {..._values, title: v},
      ),
    ),
    desc: baseField->chain(
      createField(
        ~key="desc",
        ~getValue=v => v.Value.desc,
        ~setValue=(v, _values) => {..._values, desc: v},
      ),
    ),
  }
}
