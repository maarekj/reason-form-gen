// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Caml_obj = require("rescript/lib/js/caml_obj.js");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var XmlDom$MaarekjReasonFormGen = require("./vendor/XmlDom.bs.js");

function formFromXmlAst(xml) {
  var eq = Caml_obj.caml_equal;
  var getExn = function (option, error) {
    if (option !== undefined) {
      return Caml_option.valFromOption(option);
    } else {
      return Pervasives.failwith(error);
    }
  };
  if (xml.tag !== "form") {
    return Pervasives.failwith("the root tag must be <form>");
  }
  var attrs = xml.attrs;
  var fields = Belt_Option.getWithDefault(XmlDom$MaarekjReasonFormGen.getFirstChildElement(xml, "fields"), {
        tag: "fields",
        attrs: /* [] */0,
        children: /* [] */0
      });
  return {
          withSafe: Belt_Option.getWithDefault(Belt_List.getAssoc(attrs, "withSafe", eq), "true") === "true",
          withDecco: Belt_Option.getWithDefault(Belt_List.getAssoc(attrs, "withDecco", eq), "false") === "true",
          fields: Belt_List.map(fields.children, (function (field) {
                  switch (field.tag) {
                    case "List" :
                        var attrs = field.attrs;
                        return {
                                TAG: /* List */2,
                                name: getExn(Belt_List.getAssoc(attrs, "name", eq), "'name' in List must be defined."),
                                type_: getExn(Belt_List.getAssoc(attrs, "type", eq), "'type' in List must be defined."),
                                safeType: Belt_List.getAssoc(attrs, "safeType", eq),
                                safeTransform: Belt_List.getAssoc(attrs, "safeTransform", eq),
                                module_: Belt_List.getAssoc(attrs, "module", eq),
                                empty: getExn(Belt_List.getAssoc(attrs, "empty", eq), "'empty' in List must be defined."),
                                default: Belt_List.getAssoc(attrs, "default", eq),
                                deccoKey: Belt_List.getAssoc(attrs, "deccoKey", eq)
                              };
                    case "Object" :
                        var attrs$1 = field.attrs;
                        return {
                                TAG: /* Object */1,
                                name: getExn(Belt_List.getAssoc(attrs$1, "name", eq), "'name' in Object must be defined."),
                                type_: getExn(Belt_List.getAssoc(attrs$1, "type", eq), "'type' in Object must be defined."),
                                safeType: Belt_List.getAssoc(attrs$1, "safeType", eq),
                                safeTransform: Belt_List.getAssoc(attrs$1, "safeTransform", eq),
                                module_: getExn(Belt_List.getAssoc(attrs$1, "module", eq), "'module' in Object must be defined."),
                                empty: Belt_List.getAssoc(attrs$1, "empty", eq),
                                default: Belt_List.getAssoc(attrs$1, "default", eq),
                                option: Belt_Option.getWithDefault(Belt_List.getAssoc(attrs$1, "option", eq), "false") === "true",
                                deccoKey: Belt_List.getAssoc(attrs$1, "deccoKey", eq)
                              };
                    case "Scalar" :
                        var attrs$2 = field.attrs;
                        return {
                                TAG: /* Scalar */0,
                                name: getExn(Belt_List.getAssoc(attrs$2, "name", eq), "'name' in Scalar must be defined."),
                                type_: getExn(Belt_List.getAssoc(attrs$2, "type", eq), "'type' in Scalar must be defined."),
                                safeType: Belt_List.getAssoc(attrs$2, "safeType", eq),
                                safeTransform: Belt_List.getAssoc(attrs$2, "safeTransform", eq),
                                default: Belt_List.getAssoc(attrs$2, "default", eq),
                                deccoKey: Belt_List.getAssoc(attrs$2, "deccoKey", eq)
                              };
                    case "StringMap" :
                        var attrs$3 = field.attrs;
                        return {
                                TAG: /* StringMap */3,
                                name: getExn(Belt_List.getAssoc(attrs$3, "name", eq), "'name' in StringMap must be defined."),
                                type_: getExn(Belt_List.getAssoc(attrs$3, "type", eq), "'type' in StringMap must be defined."),
                                safeType: Belt_List.getAssoc(attrs$3, "safeType", eq),
                                safeTransform: Belt_List.getAssoc(attrs$3, "safeTransform", eq),
                                module_: getExn(Belt_List.getAssoc(attrs$3, "module", eq), "'module' in StringMap must be defined."),
                                empty: getExn(Belt_List.getAssoc(attrs$3, "empty", eq), "'empty' in StringMap must be defined."),
                                default: Belt_List.getAssoc(attrs$3, "default", eq),
                                deccoKey: Belt_List.getAssoc(attrs$3, "deccoKey", eq)
                              };
                    default:
                      return Pervasives.failwith("unknown field");
                  }
                }))
        };
}

exports.formFromXmlAst = formFromXmlAst;
/* XmlDom-MaarekjReasonFormGen Not a pure module */
