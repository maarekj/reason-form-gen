const yargs = require("yargs/yargs");
const { hideBin } = require("yargs/helpers");

const Main = require("../src/Main.bs.js");

yargs(hideBin(process.argv))
    .command(
        "generate <files...>",
        "generate files",
        (yargs) => {
            return yargs.positional("files", {
                describe: "the files to generate",
                default: [],
            });
        },
        (argv) => {
            Main.generateFiles(argv.files);
        },
    )
    .option("verbose", {
        alias: "v",
        type: "boolean",
        description: "Run with verbose logging",
    })
    .parse();
