// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Belt_List = require("rescript/lib/js/belt_List.js");
var Xmldom = require("@xmldom/xmldom");
var Webapi__Dom__Element = require("rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.bs.js");

function parse(xml) {
  var parser = new Xmldom.DOMParser();
  var $$document = parser.parseFromString(xml);
  var getAttrs = function (element) {
    return Belt_List.map(Belt_List.fromArray(Array.prototype.slice.call(element.attributes)), (function (tag) {
                  return [
                          tag.name,
                          tag.value
                        ];
                }));
  };
  var handleElement = function (element) {
    return {
            tag: element.tagName,
            attrs: getAttrs(element),
            children: Belt_List.map(Belt_List.keepMap(Belt_List.map(Belt_List.fromArray(Array.prototype.slice.call(element.childNodes)), Webapi__Dom__Element.ofNode), (function (element) {
                        return element;
                      })), handleElement)
          };
  };
  return handleElement($$document.documentElement);
}

function getFirstChildElement(ast, tagName) {
  return Belt_List.getBy(ast.children, (function (child) {
                return child.tag === tagName;
              }));
}

exports.parse = parse;
exports.getFirstChildElement = getFirstChildElement;
/* @xmldom/xmldom Not a pure module */