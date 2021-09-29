/* Generated file */

module Value = {
  type t = {
    username: option<string>,
    lastname: option<string>,
    firstname: option<string>,
    gender: option<Gender.t>,
    age: int,
    tags: list<string>,
    mainAddress: option<Address.value>,
    addresses: list<Address.value>,
    metadata: Belt.Map.String.t<Metadata.value>,
  }

  let make = (
    ~username=?,
    ~lastname=?,
    ~firstname=?,
    ~gender=?,
    ~age=0,
    ~tags=list{},
    ~mainAddress=?,
    ~addresses=list{},
    ~metadata=Belt.Map.String.empty,
    (),
  ) => {
    username: username,
    lastname: lastname,
    firstname: firstname,
    gender: gender,
    age: age,
    tags: tags,
    mainAddress: mainAddress,
    addresses: addresses,
    metadata: metadata,
  }
}

type value = Value.t

type fields<'t, 'self> = {
  self: ReasonForm.Field.t<'t, 'self>,
  username: ReasonForm.Field.t<'t, option<string>>,
  lastname: ReasonForm.Field.t<'t, option<string>>,
  firstname: ReasonForm.Field.t<'t, option<string>>,
  gender: ReasonForm.Field.t<'t, option<Gender.t>>,
  age: ReasonForm.Field.t<'t, int>,
  tags: (ReasonForm.Field.t<'t, list<string>>, int => ReasonForm.Field.t<'t, string>),
  mainAddress: Address.fields<'t, option<Address.value>>,
  addresses: (
    ReasonForm.Field.t<'t, list<Address.value>>,
    int => Address.fields<'t, Address.value>,
  ),
  metadata: (
    ReasonForm.Field.t<'t, Belt.Map.String.t<Metadata.value>>,
    string => Metadata.fields<'t, Metadata.value>,
  ),
}

let createFields = (self, baseField) => {
  open ReasonForm.Field
  {
    self: self,
    username: baseField->chain(
      createField(
        ~key="username",
        ~getValue=v => v.Value.username,
        ~setValue=(v, values) => {...values, username: v},
      ),
    ),
    lastname: baseField->chain(
      createField(
        ~key="lastname",
        ~getValue=v => v.Value.lastname,
        ~setValue=(v, values) => {...values, lastname: v},
      ),
    ),
    firstname: baseField->chain(
      createField(
        ~key="firstname",
        ~getValue=v => v.Value.firstname,
        ~setValue=(v, values) => {...values, firstname: v},
      ),
    ),
    gender: baseField->chain(
      createField(
        ~key="gender",
        ~getValue=v => v.Value.gender,
        ~setValue=(v, values) => {...values, gender: v},
      ),
    ),
    age: baseField->chain(
      createField(
        ~key="age",
        ~getValue=v => v.Value.age,
        ~setValue=(v, values) => {...values, age: v},
      ),
    ),
    tags: {
      let field = chain(
        baseField,
        createField(
          ~key="tags",
          ~getValue=v => v.Value.tags,
          ~setValue=(v, values) => {...values, tags: v},
        ),
      )
      (field, makeListItemField("", field))
    },
    mainAddress: {
      let field = chain(
        baseField,
        createField(
          ~key="mainAddress",
          ~getValue=v => v.Value.mainAddress,
          ~setValue=(v, values) => {...values, mainAddress: v},
        ),
      )

      Address.createFields(field, option(field, Address.empty))
    },
    addresses: chain(
      baseField,
      createField(
        ~key="addresses",
        ~getValue=v => v.Value.addresses,
        ~setValue=(v, values) => {...values, addresses: v},
      ),
    )->chainList(Address.empty, Address.createFields),
    metadata: chain(
      baseField,
      createField(
        ~key="metadata",
        ~getValue=v => v.Value.metadata,
        ~setValue=(v, values) => {...values, metadata: v},
      ),
    )->chainStringMap(Metadata.empty, Metadata.createFields),
  }
}