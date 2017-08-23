module Jekyll
  module PDF
    class Generator < Jekyll::Generator
      safe true
      priority :lowest

      def generate(site)
        # Loop through pages & documents and build PDFs
        [site.pages.clone, site.documents].each do |items|
          items.each do |item|
            site.pages << Document.new(site, site.source, item) if item.data['pdf']
          end
        end
      end

    end
  end
end
