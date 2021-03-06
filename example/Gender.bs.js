// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Hook$ReasonForm = require("@maarekj/reason-form/src/Hook.bs.js");
var BootstrapRender$ReasonForm = require("@maarekj/reason-form/src/BootstrapRender.bs.js");

var choices = {
  hd: {
    value: /* Male */0,
    string: "male",
    label: "Male"
  },
  tl: {
    hd: {
      value: /* Female */1,
      string: "female",
      label: "Female"
    },
    tl: {
      hd: {
        value: /* Other */2,
        string: "other",
        label: "Other"
      },
      tl: /* [] */0
    }
  }
};

var optChoices_0 = {
  value: undefined,
  string: "",
  label: ""
};

var optChoices_1 = Belt_List.map(choices, (function (choice) {
        return {
                value: choice.value,
                string: choice.string,
                label: choice.label
              };
      }));

var optChoices = {
  hd: optChoices_0,
  tl: optChoices_1
};

function Gender$GenderRow(Props) {
  var wrap = Props.wrap;
  var field = Props.field;
  var expanded = Props.expanded;
  var value = Hook$ReasonForm.useValue(wrap, field);
  return React.useMemo((function () {
                var icon;
                if (value !== undefined) {
                  switch (value) {
                    case /* Male */0 :
                        icon = React.createElement("span", {
                              className: "input-group-text"
                            }, React.createElement("i", {
                                  className: "fas fa-mars"
                                }));
                        break;
                    case /* Female */1 :
                        icon = React.createElement("span", {
                              className: "input-group-text"
                            }, React.createElement("i", {
                                  className: "fas fa-venus"
                                }));
                        break;
                    case /* Other */2 :
                        icon = React.createElement("span", {
                              className: "input-group-text"
                            }, React.createElement("i", {
                                  className: "fas fa-genderless"
                                }));
                        break;
                    
                  }
                } else {
                  icon = null;
                }
                return React.createElement(BootstrapRender$ReasonForm.Row.make, {
                            label: "Gender",
                            input: React.createElement("div", {
                                  className: "input-group mb-3"
                                }, React.createElement(BootstrapRender$ReasonForm.Choice.make, {
                                      wrap: wrap,
                                      expanded: expanded,
                                      choices: optChoices,
                                      field: field
                                    }), React.createElement("div", {
                                      className: "input-group-append"
                                    }, icon)),
                            wrap: wrap,
                            field: field
                          });
              }), [
              wrap,
              expanded,
              value
            ]);
}

var GenderRow = {
  make: Gender$GenderRow
};

exports.choices = choices;
exports.optChoices = optChoices;
exports.GenderRow = GenderRow;
/* optChoices Not a pure module */
