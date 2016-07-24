require 'tmpdir'
require 'digest/md5'
require File.dirname(__FILE__) + '/helper.rb'

module Jekyll
  module PDF
    class Partial
      extend Forwardable
      include Helper

      attr_accessor :doc
      attr_accessor :partial
      attr_accessor :write
      attr_accessor :content, :ext
      attr_writer   :output

      def_delegators :@doc, :site, :name, :ext, :relative_path, :extname,
                            :render_with_liquid?, :collection, :related_posts

      # Initialize this Partial instance.
      #
      # doc - The Document.
      #
      # Returns the new Partial.
      def initialize(doc, partial)
        self.doc = doc
        self.partial = partial
        self.content = build_partial(partial)
      end

      # Fetch YAML front-matter data from related doc, without layout key
      #
      # Returns Hash of doc data
      def data
        @data ||= doc.data.dup
        @data.delete("layout")
        @data
      end

      def trigger_hooks(*)
      end

      def path
        File.join(doc.path, partial)
      end

      def id
        File.basename(path, File.extname(path)) + "-" + Digest::MD5.hexdigest(to_s) + File.extname(path)
      end

      # Returns the cache directory
      def dir
        @dir ||= cache_dir
      end

      def to_s
        output || content
      end

      def to_liquid
        doc.data[partial] = nil
        @to_liquid ||= doc.to_liquid
        doc.data[partial] = self
        @to_liquid
      end

      # Returns the shorthand String identifier of this doc.
      def inspect
        "<Partial: #{self.id}>"
      end

      def output
        @output ||= Renderer.new(doc.site, self, site.site_payload).run
      end

      # generate temp file & set output to it's path
      def write
        tempfile = File.absolute_path(File.join(dir, id))
        unless File.exist?(tempfile)
          FileUtils.mkdir_p(File.dirname(tempfile)) unless File.exist?(File.dirname(tempfile))
          fix_relative_paths
          File.open(tempfile, 'w') {|f| f.write(to_s) }
        end
        @output = tempfile

        # store path for cleanup
        site.data[:jekyll_pdf_partials] ||= []
        site.data[:jekyll_pdf_partials] << "#{self}"
      end

      def place_in_layout?
        false
      end

      protected

      def cache_dir
        return site.config["pdf"]["cache"] if site.config["pdf"] != nil && site.config["pdf"].has_key?('cache')

        # Use jekyll-assets cache directory if it exists
        cache_dir = site.config["assets"]["cache"] || '.asset-cache' if site.config["assets"] != nil

        File.join(cache_dir || Dir.tmpdir(), 'pdf')
      end

      # Internal: Generate partial html
      #
      # Partials are rendered same time as content is rendered.
      #
      # Returns partial html String
      def build_partial(path)

        # vars to insert into partial
        vars = ['frompage','topage','page','webpage','section','subsection','subsubsection']
        doc.data["pdf"] = {}
        vars.each { |var| doc.data["pdf"][var] = "<span class='__#{var}'></span>" }

        # JavaScript to replace var placeholders with content
        script = "<script>!function(){var t={},n=document.location.search.substring(1).split('&');for(var e in n){var o=n[e].split('=',2);t[o[0]]=decodeURIComponent(o[1])}var n=#{vars};for(var e in n)for(var r=document.getElementsByClassName('__'+n[e]),a=0;a<r.length;++a)r[a].textContent=t[n[e]]}();</script>\n"

        # Parse & render
        content = File.read(File.join("_includes", path))

        # Add replacer script to body
        if content =~ /<\/body>/i
          content[/(<\/body>)/i] = script + content[/(<\/body>)/i]
        else
          Jekyll.logger.warn  <<-eos
  Couldn't find <body> in #{path}. Make sure your partial is a properly formatted HTML document (including DOCTYPE) e.g.

  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8" />
  </head>
  <body>
    Page {{ pdf.page }} of {{ pdf.topage }}
  </body>
  </html>
  eos
          # No body found - insert html into default template
          content = %{<!DOCTYPE html>
  <html>
    <body>
    #{self.output}
    #{script}
    </body>
  </html>
  }
        end

        content

      end
    end
  end
end