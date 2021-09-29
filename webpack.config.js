const path = require("path");
const webpack = require("webpack");

var config = {
    target: "node",
    mode: "development",
    entry: {
        index: ["./example/Example_Index.bs.js"],
    },
    output: {
        path: path.join(__dirname, "public", "build"),
        filename: "[name].js",
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ["env"],
                    },
                },
            },
        ],
    },
};

module.exports = [config];
