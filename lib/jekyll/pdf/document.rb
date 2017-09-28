require 'pdfkit'
require File.dirname(__FILE__) + '/helper.rb'

module Jekyll
  module PDF
    class Document < Jekyll::Page
      include Helper

      def initialize(site, base, page)
        @site = site
        @base = base
        @dir = File.dirname(page.url)
        @name = File.basename(page.url, File.extname(page.url)) + '.pdf'
        @settings = site.config.key?('pdf') ? site.config['pdf'].clone : {}
        @partials = %w[cover header_html footer_html]

        process(@name)
        self.data = page.data.clone
        self.content = page.content.clone

        # Set layout to the PDF layout
        data['layout'] = layout

        # Get PDF settings from the layouts
        Jekyll::Utils.deep_merge_hashes!(@settings, getConfig(data))

        PDFKit.configure do |config|
          config.verbose = site.config['verbose']
        end

        # Set pdf_url variable in the source page (for linking to the PDF version)
        page.data['pdf_url'] = url

        # Set html_url variable in the source page (for linking to the HTML version)
        data['html_url'] = page.url

        # create the partial objects
        @partials.each do |partial|
          @settings[partial] = Jekyll::PDF::Partial.new(self, @settings[partial]) unless @settings[partial].nil?
        end

        data.default_proc = proc do |_, key|
          site.frontmatter_defaults.find(File.join(dir, name), type, key)
        end
        Jekyll::Hooks.trigger :pages, :post_init, self
      end

      # Recursively merge settings from the page, layout, site config & jekyll-pdf defaults
      def getConfig(data)
        settings = data['pdf'].is_a?(Hash) ? data['pdf'] : {}
        layout = @site.layouts[data['layout']].data.clone unless data['layout'].nil?

        # No parent layout found - return settings hash
        return settings if layout.nil?

        # Merge settings with parent layout settings
        layout['pdf'] ||= {}
        Jekyll::Utils.deep_merge_hashes!(layout['pdf'], settings)

        getConfig(layout)
      end

      # Write the PDF file
      # todo: remove pdfkit dependency
      def write(dest_prefix, _dest_suffix = nil)
        render(@site.layouts, @site.site_payload) if output.nil?

        path = File.join(dest_prefix, CGI.unescape(url))
        dest = File.dirname(path)

        # Create directory
        FileUtils.mkdir_p(dest) unless File.exist?(dest)

        # write partials
        @partials.each do |partial|
          @settings[partial].write unless @settings[partial].nil?
        end

        # Debugging - create html version of PDF
        File.open("#{path}.html", 'w') { |f| f.write(output) } if @settings['debug']
        @settings.delete('debug')
        @settings.delete('layout')

        # Build PDF file
        fix_relative_paths
        kit = PDFKit.new(output, @settings)
        file = kit.to_file(path)
      end

      def layout
        # Set page layout to the PDF layout
        layout = data['pdf_layout'] || @settings['layout']

        # Check if a PDF version exists for the current layout (e.g. layout_pdf)
        if layout.nil? && !data['layout'].nil? && File.exist?('_layouts/' + data['layout'] + '_pdf.html')
          layout = data['layout'] + '_pdf'
        end

        layout || 'pdf'
      end
    end
  end
end
