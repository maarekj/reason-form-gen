@deriving(abstract)
type mkdirOptions = {
  @optional
  recursive: bool,
  @optional
  mode: string,
}

@module("fs") external mkdirSync: (string, mkdirOptions) => option<string> = "mkdirSync"

let mkdirRecurisveSync = (path, ~mode=?, ()) => {
  mkdirSync(path, mkdirOptions(~recursive=true, ~mode?, ()))
}
