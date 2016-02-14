# https://github.com/documentcloud/closure-compiler
require 'rubygems'
require 'closure-compiler'

module Jekyll
  module JsMinify
    
    class MinJsFile < Jekyll::StaticFile

      def closure_args()
        closure_args = {}
        config_jsminify = @site.config['jsminify'] || {}
        config_current = config_jsminify[@name] || {}

        if config_current['advanced_optimizations'] || (
            !config_current.key?('advanced_optimizations') && config_jsminify['advanced_optimizations'] )
          closure_args[:compilation_level] = 'ADVANCED_OPTIMIZATIONS'
        end

        if config_current.key?('externs')
          closure_args[:externs] = config_current['externs'].map { |d| File.join(@site.source, d) }
        end

        closure_args
      end
      
      # Minify JS
      #   +dest+ is the String path to the destination dir
      #
      # Returns false if the file was not modified since last time (no-op).
      def write(dest)
        dest_path = File.join(dest, @dir, @name)
        
        return false if File.exist? dest and !modified?
        @@mtimes[path] = mtime

        FileUtils.mkdir_p(File.dirname(dest_path))
        begin
          content = File.read(path)
          content = Closure::Compiler.new(closure_args()).compile(content)
          File.open(dest_path, 'w') do |f|
            f.write(content)
          end
        rescue => e
          STDERR.puts "Closure Compiler Exception: #{e.message}"
        end

        true
      end

    end

    class JsGenerator < Jekyll::Generator
      safe true

      # Jekyll will have already added the *.js files as Jekyll::StaticFile
      # objects to the static_files array.  Here we replace those with a
      # MinJSFile object.
      def generate(site)
        if !site.config['watch']
          site.static_files.clone.each do |sf|
            if sf.kind_of?(Jekyll::StaticFile) && sf.path =~ /\.js$/ && !(sf.path =~ /\.min\.js$/)
              site.static_files.delete(sf)
              name = File.basename(sf.path)
              destination = File.dirname(sf.path).sub(site.source, '')
              site.static_files << MinJsFile.new(site, site.source, destination, name)
            end
          end
        end
      end
    end

  end
end
