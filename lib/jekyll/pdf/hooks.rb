# Delete temp files
Jekyll::Hooks.register :site, :post_write do |jekyll, payload|
  if jekyll.data[:jekyll_pdf_partials]
    jekyll.data[:jekyll_pdf_partials].each do |partial|
      partial.clean
    end
    jekyll.data.delete(:jekyll_pdf_partials)
  end
end