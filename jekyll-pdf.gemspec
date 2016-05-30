Gem::Specification.new do |spec|
  spec.version = "0.1.0"
  spec.homepage = "http://github.com/abemedia/jekyll-pdf/"
  spec.authors = ["Adam Bouqdib"]
  spec.email = ["adam@abemedia.co.uk"]
  spec.files = %W(Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "PDF generator for Jekyll"
  spec.name = "jekyll-pdf"
  spec.license = "GPL-3.0"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    A Jekyll plugin, that allows you to create PDF versions of your pages & documents.
  DESC

  spec.add_runtime_dependency("wkhtmltopdf-installer", "~> 0.12")
  spec.add_runtime_dependency("pdfkit", "~> 0.8")
  spec.add_runtime_dependency("digest", "~> 0")
  spec.add_runtime_dependency("activesupport", "~> 4.2")
  spec.add_runtime_dependency("jekyll", ">= 2.0", "~> 3.1")

  spec.add_development_dependency "bundler", "~> 1.6"
end