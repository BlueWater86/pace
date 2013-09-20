Path = require('path')
fs = require('fs')

ThemeUtils = require('./docs/lib/themes.coffee')

module.exports = (grunt) ->
  grunt.registerTask 'themes', 'Compile the pace theme files', ->
    done = @async()

    options = grunt.config('themes')

    grunt.file.glob options.src, (err, files) ->
      for file in files
        body = ThemeUtils.compileTheme fs.readFileSync(file).toString()

        body = "// This is a compiled file, you should be editing the file in templates/\n" + body

        name = Path.basename file
        name = name.replace '.tmpl', ''
        path = Path.join options.dest, name

        fs.writeFileSync path, body

      done()

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      compile:
        files:
          'pace.js': 'pace.coffee'
          'docs/lib/themes.js': 'docs/lib/themes.coffee'

    watch:
      coffee:
        files: ['pace.coffee', 'docs/lib/themes.coffee', 'templates/*']
        tasks: ["coffee", "uglify", "themes"]

    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= pkg.version %> */\n"

      dist:
        src: 'pace.js'
        dest: 'pace.min.js'

    themes:
      src: 'templates/*.tmpl.css'
      dest: '.'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'default', ['coffee', 'uglify', 'themes']
