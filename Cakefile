fs = require "fs"
{exec} = require "child_process"

pwd = __dirname

publicFolders = [
    "public"
    "public/js"
    "public/css"
    "public/less"
    "public/coffee"
]

libraries =
    "js": [
        "less/dist/less.min.js"
        "jquery/dist/jquery.min.js"
        "jquery/dist/jquery.min.map"
        "coffee-script/extras/coffee-script.js"
    ]
    "css": [
        "bootstrap/dist/css/bootstrap.min.css"
    ]

task "build",
    "Main build",
    ->
        invoke "copyLibraries"
        invoke "copyAssets"

task "createFolders",
    "Creates the necessary folders for further process",
    ->
        for folder in publicFolders
            fs.mkdirSync folder unless fs.existsSync folder


task "copyLibraries",
    "Copy static libraries to public folder",
    ->
        invoke "createFolders"

        for type, files of libraries
            for file in files
                exec "cp -f #{pwd}/bower_components/#{file} #{pwd}/public/#{type}"

task "copyAssets",
    "Copy user assets to public folder",
    ->
        invoke "createFolders"

        exec "cp -Rf #{pwd}/assets/* #{pwd}/public/"

invoke "build"