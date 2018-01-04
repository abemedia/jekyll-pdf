begin
  require 'jekyll-assets'

  module Jekyll
    module PDF
      class AssetsTag < Jekyll::Assets::Liquid::Tag

        # --------------------------------------------------------------------
        # Tags that we allow our users to use.
        # --------------------------------------------------------------------

        AcceptableTags = %W(
          pdf_img
          pdf_image
          pdf_javascript
          pdf_stylesheet
          pdf_asset_path
          pdf_style
          pdf_css
          pdf_js
        ).freeze

        def initialize(tag, args, tokens)
          tag = tag.to_s.sub!("pdf_", "")
          super(tag, args, tokens)
        end

        def render(context)
          @path_prefix = "file://" + context.registers[:site].dest
          super
        end

        private
        def build_html(args, sprockets, asset, path = get_path(sprockets, asset))
          data = @path_prefix + (args.key?(:data) && args[:data].key?(:uri) ? asset.data_uri : path)
          format(Jekyll::Assets::Liquid::Tag::Tags[@tag], data, args.to_html)
        end

      end
    end
  end

  Jekyll::PDF::AssetsTag::AcceptableTags.each do |tag|
    Liquid::Template.register_tag tag, Jekyll::PDF::AssetsTag
  end
rescue LoadError
end