# jekyll-js-minify-plugin

A Jekyll plugin that automatically minifies all Javascript files using the Google Closure Compiler

## Usage

    gem install 'closure-compiler'
    cp jsminify.rb YOUR_JEKYLL_DIR/_plugins/

That's it. All files ending in `.js` will be minified. Files ending in `.min.js` will be skipped. It's almost magical.

## Enable ADVANCED_OPTIMIZATIONS

Jsminify can be configured to use closure compiler's ADVANCED_OPTIMIZATIONS globally or on file to file basis. Just add something similiar to your _config.yml:

    jsminify:
        # enable/disable advanced_optimizations globally - file specific configuration takes precedence
        # default: false
        advanced_optimizations: false
        
        # file specific configuration - file name must match exactly
        some_file.js:
            # overwrite global advanced_optimizations property
            advanced_optimizations: true
            
            # select externs declarations to be used for this file (see closure compiler documentation)
            # this can't be configured globally
            # default: none
            externs:
                - path/to/externs.js
                - other/path/to/externs.js
        
        some_other_file.js:
            advanced_optimizations: true
            externs:
                - path/to/externs.js
