type t =
  | Male
  | Female
  | Other

let choices = list{
  {ReasonForm.BootstrapRender.Choice.value: Male, string: "male", label: "Male"},
  {value: Female, string: "female", label: "Female"},
  {value: Other, string: "other", label: "Other"},
}

let optChoices = list{
  {ReasonForm.BootstrapRender.Choice.value: None, string: "", label: ""},
  ...choices->Belt.List.map(choice => {...choice, value: Some(choice.value)}),
}

module GenderRow = {
  @react.component
  let make = (~wrap, ~field: ReasonForm.Field.t<_, option<t>>, ~expanded) => {
    let value = ReasonForm.Hook.useValue(wrap, field)

    React.useMemo3(() => {
      let icon = switch value {
      | None => React.null
      | Some(Male) => <span className="input-group-text"> <i className="fas fa-mars" /> </span>
      | Some(Female) => <span className="input-group-text"> <i className="fas fa-venus" /> </span>
      | Some(Other) =>
        <span className="input-group-text"> <i className="fas fa-genderless" /> </span>
      }

      <ReasonForm.BootstrapRender.Row
        label=`Gender`
        wrap
        field
        input={<div className="input-group mb-3">
          <ReasonForm.BootstrapRender.Choice wrap expanded field choices=optChoices />
          <div className="input-group-append"> icon </div>
        </div>}
      />
    }, (wrap, expanded, value))
  }
}
