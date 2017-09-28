# Delete temp files
Jekyll::Hooks.register :site, :post_write do |jekyll, _payload|
  if jekyll.data[:jekyll_pdf_partials]
    jekyll.data[:jekyll_pdf_partials].each do |partial|
      File.delete(partial) if File.exist?(partial)
    end
    jekyll.data.delete(:jekyll_pdf_partials)
  end
end
