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
        "coffee-script/extras/coffee-script.js"
    ]
    "css": [
        "bootstrap/dist/css/bootstrap.min.css"
    ]

task "development",
    "Development build.",
    ->
        invoke "copyLibraries"

task "production",
    "Production build.",
    ->
        invoke "copyLibraries"
        invoke "copyImages"
        invoke "compilejs"
        invoke "compilecss"

task "phpbuild",
    "PHP build.",
    ->
        invoke "copyLibraries"
        invoke "copyLibraries"
        invoke "copyImages"
        invoke "compilejs"
        invoke "compilecss"
        invoke "compileHTML"

task "prepareFolders",
    "Creates the necessary folders for further process.",
    ->
        for folder in publicFolders
            fs.mkdirSync folder unless fs.existsSync folder

task "copyLibraries",
    "Copy static libraries to public folder.",
    ->
        invoke "prepareFolders"

        for type, files of libraries
            for file in files
                exec "cp -f #{pwd}/bower_components/#{file} #{pwd}/public/#{type}"

task "copyImages",
    "Copy images to public folder.",
    ->
        invoke "prepareFolders"
        exec "cp #{pwd}/assets/images/* #{pwd}/public/images/"

task "compilejs",
    "Compiles coffeescript to javascript.",
    ->
        invoke "prepareFolders"

        fs.mkdirSync "#{pwd}/assets/js" unless fs.existsSync "#{pwd}/assets/js"

        exec "coffee --compile --bare --output #{pwd}/assets/js #{pwd}/assets/coffee", ->
            for file in fs.readdirSync "#{pwd}/assets/js"
                exec "uglifyjs --unsafe --output #{pwd}/public/js/#{file} #{pwd}/assets/js/#{file}"

task "compilecss",
    "Compiles less to css.",
    ->
        invoke "prepareFolders"
        for file in fs.readdirSync "#{pwd}/assets/less"
            filename = file.slice 0, -5
            exec "lessc -x #{pwd}/assets/less/#{file} > #{pwd}/public/css/#{filename}.css"

task "compileHTML",
    "Compiles jade to html.",
    ->
        invoke "prepareFolders"

        jade = require "jade"

        options =
            pretty: true

        for file in fs.readdirSync "#{pwd}/views" when file isnt "html.jade"
            filename = file.slice 0, -5

            content = fs.readFileSync "#{pwd}/views/" + file, encoding: "utf8"

            content = content.replace 'script(type="text/javascript", src="js/less.min.js")', ''
            content = content.replace 'script(type="text/javascript", src="js/coffee-script.js")', ''
            content = content.replace /link\(rel="stylesheet\/less", type="text\/css", href="less\/(.*).less"\)/, 'link(rel="stylesheet", type="text/css", href="css/$1.css")'
            content = content.replace /script\(type="text\/coffeescript", src="coffee\/(.*)\.coffee"\)/, 'script(type="text/javascript", src="js/$1.js")'

            fs.writeFileSync "#{pwd}/public/" + filename + ".html", jade.render(content, options), encoding: "utf8"