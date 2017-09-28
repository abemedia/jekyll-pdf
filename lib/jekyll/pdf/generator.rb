module Jekyll
  module PDF
    class Generator < Jekyll::Generator
      safe true
      priority :lowest

      def generate(site)
        [site.pages.clone, site.documents].flatten.each do |item|
          site.pages << Document.new(site, site.source, item) if item.data['pdf']
        end
      end
    end
  end
end
