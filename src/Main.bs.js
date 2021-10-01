// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Path = require("path");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Config$MaarekjReasonFormGen = require("./Config.bs.js");
var XmlDom$MaarekjReasonFormGen = require("./vendor/XmlDom.bs.js");
var Node_Fs$MaarekjReasonFormGen = require("./vendor/Node_Fs.bs.js");

function join(list, sep) {
  if (list) {
    return list.hd + sep + join(list.tl, sep);
  } else {
    return "";
  }
}

function generateForm(file, form) {
  var getDefaultFromField = function (field) {
    if (field.TAG === /* Scalar */0) {
      return field.default;
    } else {
      return field.default;
    }
  };
  var generateModuleValue = function (param) {
    return "module Value = {\n    type t = {\n" + join(Belt_List.map(form.fields, (function (field) {
                      switch (field.TAG | 0) {
                        case /* Scalar */0 :
                            return field.name + ": " + field.type_;
                        case /* Object */1 :
                            var type_ = field.type_;
                            var name = field.name;
                            if (field.option) {
                              return name + ": option<" + type_ + ">";
                            } else {
                              return name + ": " + type_;
                            }
                        case /* List */2 :
                            return field.name + ": list<" + field.type_ + ">";
                        case /* StringMap */3 :
                            return field.name + ": Belt.Map.String.t<" + field.type_ + ">";
                        
                      }
                    })), ",\n") + "\n    }\n\n    let make = (\n" + join(Belt_List.map(form.fields, (function (field) {
                      var match = getDefaultFromField(field);
                      var match$1 = field.name;
                      if (match !== undefined) {
                        return "~" + match$1 + "=" + match;
                      } else {
                        return "~" + match$1;
                      }
                    })), ",\n") + "\n        (),\n    ) => {\n\n" + join(Belt_List.map(form.fields, (function (field) {
                      return "        " + field.name + ": " + field.name;
                    })), ",\n") + "\n    }\n}\n\ntype value = Value.t\n\n";
  };
  var generateModuleSafe = function (param) {
    if (form.withSafe === false) {
      return "";
    }
    var hasSafe = Belt_List.some(form.fields, (function (field) {
            if (field.safeType !== undefined) {
              return true;
            } else {
              return field.safeTransform !== undefined;
            }
          }));
    if (false === hasSafe) {
      return "\n      module Safe = {\n        type t = value\n        let fromValue = (value: value) : option<t> => Some(value)\n        let fromValueExn = fromValue\n      }\n\n      type safe = Safe.t\n      ";
    } else {
      return "module Safe = {\n      type t = {\n      " + join(Belt_List.map(form.fields, (function (field) {
                        var name;
                        var safeType;
                        switch (field.TAG | 0) {
                          case /* Scalar */0 :
                              var safeType$1 = field.safeType;
                              var name$1 = field.name;
                              if (safeType$1 === undefined) {
                                return name$1 + ": " + field.type_;
                              }
                              name = name$1;
                              safeType = safeType$1;
                              break;
                          case /* Object */1 :
                              var safeType$2 = field.safeType;
                              var name$2 = field.name;
                              if (safeType$2 !== undefined) {
                                name = name$2;
                                safeType = safeType$2;
                              } else {
                                var type_ = field.type_;
                                if (field.option) {
                                  return name$2 + ": option<" + type_ + ">";
                                } else {
                                  return name$2 + ": " + type_;
                                }
                              }
                              break;
                          case /* List */2 :
                              var safeType$3 = field.safeType;
                              var name$3 = field.name;
                              if (safeType$3 === undefined) {
                                return name$3 + ": list<" + field.type_ + ">";
                              }
                              name = name$3;
                              safeType = safeType$3;
                              break;
                          case /* StringMap */3 :
                              var safeType$4 = field.safeType;
                              var name$4 = field.name;
                              if (safeType$4 === undefined) {
                                return name$4 + ": Belt.Map.String.t<" + field.type_ + ">";
                              }
                              name = name$4;
                              safeType = safeType$4;
                              break;
                          
                        }
                        return name + ": " + safeType;
                      })), ",\n") + "\n      }\n\n      let fromValue = (value: value): option<t> => {\n        try {\n          Some({" + join(Belt_List.map(form.fields, (function (field) {
                        var exit = 0;
                        var name;
                        var transform;
                        var name$1;
                        switch (field.TAG | 0) {
                          case /* Scalar */0 :
                              var transform$1 = field.safeTransform;
                              var name$2 = field.name;
                              if (transform$1 !== undefined) {
                                name = name$2;
                                transform = transform$1;
                                exit = 1;
                              } else {
                                name$1 = name$2;
                                exit = 2;
                              }
                              break;
                          case /* Object */1 :
                              var transform$2 = field.safeTransform;
                              var name$3 = field.name;
                              if (transform$2 !== undefined) {
                                name = name$3;
                                transform = transform$2;
                                exit = 1;
                              } else {
                                name$1 = name$3;
                                exit = 2;
                              }
                              break;
                          case /* List */2 :
                              var transform$3 = field.safeTransform;
                              var name$4 = field.name;
                              if (transform$3 !== undefined) {
                                name = name$4;
                                transform = transform$3;
                                exit = 1;
                              } else {
                                name$1 = name$4;
                                exit = 2;
                              }
                              break;
                          case /* StringMap */3 :
                              var transform$4 = field.safeTransform;
                              var name$5 = field.name;
                              if (transform$4 !== undefined) {
                                name = name$5;
                                transform = transform$4;
                                exit = 1;
                              } else {
                                name$1 = name$5;
                                exit = 2;
                              }
                              break;
                          
                        }
                        switch (exit) {
                          case 1 :
                              return name + ": (value." + name + ")->" + transform;
                          case 2 :
                              return name$1 + ": value." + name$1;
                          
                        }
                      })), ",\n") + "\n      })\n        } catch {\n          | _ => None\n        }\n      }\n\n      let fromValueExn = (value: value): t => fromValue(value)->Belt.Option.getExn\n    }\n    \n    type safe = Safe.t\n    ";
    }
  };
  var generateFieldsType = function (param) {
    return "type fields<'t, 'self> = {\n    self: ReasonForm.Field.t<'t, 'self>,\n" + join(Belt_List.map(form.fields, (function (field) {
                      switch (field.TAG | 0) {
                        case /* Scalar */0 :
                            return "    " + field.name + ": ReasonForm.Field.t<'t, " + field.type_ + ">";
                        case /* Object */1 :
                            var module_ = field.module_;
                            var type_ = field.type_;
                            var name = field.name;
                            if (field.option) {
                              return "    " + name + ": " + module_ + ".fields<'t, option<" + type_ + ">>";
                            } else {
                              return "    " + name + ": " + module_ + ".fields<'t, " + type_ + ">";
                            }
                        case /* List */2 :
                            var module_$1 = field.module_;
                            var type_$1 = field.type_;
                            var name$1 = field.name;
                            if (module_$1 !== undefined) {
                              return "    " + name$1 + ": (ReasonForm.Field.t<'t, list<" + type_$1 + ">>, int => " + module_$1 + ".fields<'t, " + type_$1 + ">)";
                            } else {
                              return "    " + name$1 + ": (ReasonForm.Field.t<'t, list<" + type_$1 + ">>, int => ReasonForm.Field.t<'t, " + type_$1 + ">)";
                            }
                        case /* StringMap */3 :
                            var type_$2 = field.type_;
                            return "    " + field.name + ": (ReasonForm.Field.t<'t, Belt.Map.String.t<" + type_$2 + ">>, string => " + field.module_ + ".fields<'t, " + type_$2 + ">)";
                        
                      }
                    })), ",\n") + "\n}";
  };
  var generateCreateFields = function (param) {
    var spreadValues = Belt_List.length(form.fields) <= 1 ? "" : "...values,";
    return "let createFields = (self, baseField) => {\n  open ReasonForm.Field\n  {\n    self: self,\n" + join(Belt_List.map(form.fields, (function (field) {
                      switch (field.TAG | 0) {
                        case /* Scalar */0 :
                            var name = field.name;
                            return "    " + name + ": baseField->chain(\n        createField(\n            ~key=\"" + name + "\",\n            ~getValue=v => v.Value." + name + ",\n            ~setValue=(v, values) => {" + spreadValues + " " + name + ": v},\n        ),\n    )";
                        case /* Object */1 :
                            var empty = field.empty;
                            var module_ = field.module_;
                            var name$1 = field.name;
                            if (field.option) {
                              if (empty !== undefined) {
                                return "    " + name$1 + ": {\n        let field = chain(\n            baseField,\n            createField(\n                ~key=\"" + name$1 + "\",\n                ~getValue=v => v.Value." + name$1 + ",\n                ~setValue=(v, values) => {" + spreadValues + " " + name$1 + ": v},\n            ),\n        )\n\n        " + module_ + ".createFields(field, option(field, " + empty + "))\n      }";
                              } else {
                                return Pervasives.failwith("error: if object 'option' is given, 'empty' must be given.");
                              }
                            } else {
                              return "    " + name$1 + ": {\n        let field = chain(\n            baseField,\n            createField(\n                ~key=\"" + name$1 + "\",\n                ~getValue=v => v.Value." + name$1 + ",\n                ~setValue=(v, values) => {" + spreadValues + " " + name$1 + ": v},\n            ),\n        )\n\n        " + module_ + ".createFields(field, field)\n      }";
                            }
                        case /* List */2 :
                            var module_$1 = field.module_;
                            var name$2 = field.name;
                            if (module_$1 !== undefined) {
                              return "    " + name$2 + ": chain(\n            baseField,\n            createField(\n                ~key=\"" + name$2 + "\",\n                ~getValue=v => v.Value." + name$2 + ",\n                ~setValue=(v, values) => {" + spreadValues + " " + name$2 + ": v},\n            ),\n        )->chainList(" + field.empty + ", " + module_$1 + ".createFields)\n      ";
                            } else {
                              return "    " + name$2 + ": {\n            let field = chain(\n            baseField,\n            createField(\n                ~key=\"" + name$2 + "\",\n                ~getValue=v => v.Value." + name$2 + ",\n                ~setValue=(v, values) => {" + spreadValues + " " + name$2 + ": v},\n            ),\n        )\n        (field, makeListItemField(" + field.empty + ", field))\n      }";
                            }
                        case /* StringMap */3 :
                            var name$3 = field.name;
                            return "    " + name$3 + ": chain(\n            baseField,\n            createField(\n                ~key=\"" + name$3 + "\",\n                ~getValue=v => v.Value." + name$3 + ",\n                ~setValue=(v, values) => {" + spreadValues + " " + name$3 + ": v},\n            ),\n        )->chainStringMap(" + field.empty + ", " + field.module_ + ".createFields)\n      ";
                        
                      }
                    })), ",\n") + "\n  }\n}";
  };
  var content = "/* Generated file */\n\n" + generateModuleValue(undefined) + "\n\n" + generateModuleSafe(undefined) + "\n\n" + generateFieldsType(undefined) + "\n\n" + generateCreateFields(undefined);
  var dirname = Path.dirname(file);
  var basename = Path.basename(file);
  var firstPart = Belt_List.head(Belt_List.fromArray(basename.split(".")));
  if (firstPart === undefined) {
    return Pervasives.failwith("firstPart is empty");
  }
  var outPath = Path.join(dirname, "Generated", "Generated_" + firstPart + ".res");
  Node_Fs$MaarekjReasonFormGen.mkdirRecurisveSync(Path.join(dirname, "Generated"), undefined, undefined);
  console.log("generate " + outPath);
  Fs.writeFileSync(outPath, content, "utf8");
  
}

function generateFiles(files) {
  var _files = Belt_List.fromArray(files);
  while(true) {
    var files$1 = _files;
    if (!files$1) {
      return ;
    }
    var file = files$1.hd;
    var content = Fs.readFileSync(file, "utf8");
    var xmlAst = XmlDom$MaarekjReasonFormGen.parse(content);
    var form = Config$MaarekjReasonFormGen.formFromXmlAst(xmlAst);
    generateForm(file, form);
    _files = files$1.tl;
    continue ;
  };
}

exports.join = join;
exports.generateForm = generateForm;
exports.generateFiles = generateFiles;
/* fs Not a pure module */
