// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Belt_List = require("rescript/lib/js/belt_List.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Field$ReasonForm = require("@maarekj/reason-form/src/Field.bs.js");
var Address$MaarekjReasonFormGen = require("../Address.bs.js");
var Metadata$MaarekjReasonFormGen = require("../Metadata.bs.js");
var Generated_Address$MaarekjReasonFormGen = require("./Generated_Address.bs.js");

function make(username, lastname, firstname, gender, ageOpt, tagsOpt, mainAddress, addressesOpt, metadataOpt, param) {
  var age = ageOpt !== undefined ? ageOpt : 0;
  var tags = tagsOpt !== undefined ? tagsOpt : /* [] */0;
  var addresses = addressesOpt !== undefined ? addressesOpt : /* [] */0;
  var metadata = metadataOpt !== undefined ? Caml_option.valFromOption(metadataOpt) : undefined;
  return {
          username: username,
          lastname: lastname,
          firstname: firstname,
          gender: gender,
          age: age,
          tags: tags,
          mainAddress: mainAddress,
          addresses: addresses,
          metadata: metadata
        };
}

var Value = {
  make: make
};

function fromValue(value) {
  try {
    return {
            username: Belt_Option.getExn(value.username),
            lastname: Belt_Option.getExn(value.lastname),
            firstname: Belt_Option.getExn(value.firstname),
            gender: Belt_Option.getExn(value.gender),
            age: value.age,
            tags: value.tags,
            mainAddress: value.mainAddress,
            addresses: Belt_List.map(value.addresses, Generated_Address$MaarekjReasonFormGen.Safe.fromValueExn),
            metadata: value.metadata
          };
  }
  catch (exn){
    return ;
  }
}

function fromValueExn(value) {
  return Belt_Option.getExn(fromValue(value));
}

var Safe = {
  fromValue: fromValue,
  fromValueExn: fromValueExn
};

function createFields(self, baseField) {
  var field = Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("tags", (function (v) {
              return v.tags;
            }), (function (v, _values) {
              return {
                      username: _values.username,
                      lastname: _values.lastname,
                      firstname: _values.firstname,
                      gender: _values.gender,
                      age: _values.age,
                      tags: v,
                      mainAddress: _values.mainAddress,
                      addresses: _values.addresses,
                      metadata: _values.metadata
                    };
            })));
  var field$1 = Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("mainAddress", (function (v) {
              return v.mainAddress;
            }), (function (v, _values) {
              return {
                      username: _values.username,
                      lastname: _values.lastname,
                      firstname: _values.firstname,
                      gender: _values.gender,
                      age: _values.age,
                      tags: _values.tags,
                      mainAddress: v,
                      addresses: _values.addresses,
                      metadata: _values.metadata
                    };
            })));
  return {
          self: self,
          username: Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("username", (function (v) {
                      return v.username;
                    }), (function (v, _values) {
                      return {
                              username: v,
                              lastname: _values.lastname,
                              firstname: _values.firstname,
                              gender: _values.gender,
                              age: _values.age,
                              tags: _values.tags,
                              mainAddress: _values.mainAddress,
                              addresses: _values.addresses,
                              metadata: _values.metadata
                            };
                    }))),
          lastname: Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("lastname", (function (v) {
                      return v.lastname;
                    }), (function (v, _values) {
                      return {
                              username: _values.username,
                              lastname: v,
                              firstname: _values.firstname,
                              gender: _values.gender,
                              age: _values.age,
                              tags: _values.tags,
                              mainAddress: _values.mainAddress,
                              addresses: _values.addresses,
                              metadata: _values.metadata
                            };
                    }))),
          firstname: Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("firstname", (function (v) {
                      return v.firstname;
                    }), (function (v, _values) {
                      return {
                              username: _values.username,
                              lastname: _values.lastname,
                              firstname: v,
                              gender: _values.gender,
                              age: _values.age,
                              tags: _values.tags,
                              mainAddress: _values.mainAddress,
                              addresses: _values.addresses,
                              metadata: _values.metadata
                            };
                    }))),
          gender: Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("gender", (function (v) {
                      return v.gender;
                    }), (function (v, _values) {
                      return {
                              username: _values.username,
                              lastname: _values.lastname,
                              firstname: _values.firstname,
                              gender: v,
                              age: _values.age,
                              tags: _values.tags,
                              mainAddress: _values.mainAddress,
                              addresses: _values.addresses,
                              metadata: _values.metadata
                            };
                    }))),
          age: Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("age", (function (v) {
                      return v.age;
                    }), (function (v, _values) {
                      return {
                              username: _values.username,
                              lastname: _values.lastname,
                              firstname: _values.firstname,
                              gender: _values.gender,
                              age: v,
                              tags: _values.tags,
                              mainAddress: _values.mainAddress,
                              addresses: _values.addresses,
                              metadata: _values.metadata
                            };
                    }))),
          tags: [
            field,
            (function (param) {
                return Field$ReasonForm.makeListItemField("", field, param);
              })
          ],
          mainAddress: Address$MaarekjReasonFormGen.createFields(field$1, Field$ReasonForm.option(field$1, Address$MaarekjReasonFormGen.empty)),
          addresses: Field$ReasonForm.chainList(Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("addresses", (function (v) {
                          return v.addresses;
                        }), (function (v, _values) {
                          return {
                                  username: _values.username,
                                  lastname: _values.lastname,
                                  firstname: _values.firstname,
                                  gender: _values.gender,
                                  age: _values.age,
                                  tags: _values.tags,
                                  mainAddress: _values.mainAddress,
                                  addresses: v,
                                  metadata: _values.metadata
                                };
                        }))), Address$MaarekjReasonFormGen.empty, Address$MaarekjReasonFormGen.createFields),
          metadata: Field$ReasonForm.chainStringMap(Field$ReasonForm.chain(baseField, Field$ReasonForm.createField("metadata", (function (v) {
                          return v.metadata;
                        }), (function (v, _values) {
                          return {
                                  username: _values.username,
                                  lastname: _values.lastname,
                                  firstname: _values.firstname,
                                  gender: _values.gender,
                                  age: _values.age,
                                  tags: _values.tags,
                                  mainAddress: _values.mainAddress,
                                  addresses: _values.addresses,
                                  metadata: v
                                };
                        }))), Metadata$MaarekjReasonFormGen.empty, Metadata$MaarekjReasonFormGen.createFields)
        };
}

exports.Value = Value;
exports.Safe = Safe;
exports.createFields = createFields;
/* Address-MaarekjReasonFormGen Not a pure module */
