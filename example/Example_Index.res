module App = {
  @react.component
  let make = () => {
    <User.Form />
  }
}

switch ReactDOM.querySelector("#app") {
| Some(app) => ReactDOM.render(<App />, app)
| None => failwith("#app not found")
}
