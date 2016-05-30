# Jekyll PDF

Dynamically generate PDFs from Jekyll pages, posts &amp; documents.

[![Build Status](https://travis-ci.org/abeMedia/jekyll-pdf.svg?branch=master)](https://travis-ci.org/abeMedia/jekyll-pdf)
[![Dependency Status](https://gemnasium.com/badges/github.com/abeMedia/jekyll-pdf.svg)](https://gemnasium.com/github.com/abeMedia/jekyll-pdf)

## Usage

Add `gem "jekyll-pdf"` to your `Gemfile` and run `bundle`, then add `jekyll-pdf` to your `_config.yml` like so:

```yaml
gems:
  - jekyll-pdf
```

Now add `pdf: true` to any page's or document's front-matter, that you'd like to create a PDF version of.

To activate **Jekyll PDF** for multiple pages or entire collections you can use Jekyll's [front-matter defaults](https://jekyllrb.com/docs/configuration/#front-matter-defaults). The following example will create PDFs for each post in your blog.

```yaml
defaults:
  -
    scope:
      path: ""
      type: "posts"
    values:
      pdf: true
```

Link to the PDF using the `{{ page.pdf_url }}` liquid variable.


## Configuration

**Jekyll PDF** supports any configuration parameters [wkhtmltopdf](http://wkhtmltopdf.org/) does. For a full list of configuration parameters it supports see http://wkhtmltopdf.org/usage/wkhtmltopdf.txt

```yaml
pdf:
  cache: false | directory | default: .asset-cache
  page_size: A4, Letter, etc. | default: A4
  layout: layout | default: pdf
```

All configuration parameters (with exception of `cache`) can be overridden from your page's or it's PDF layout's front-matter.

### Cache Folder

If Jekyll Assets is installed, Jekyll PDF will automatically use the same cache folder as Jekyll Assets (unless specified otherwise).

## Layouts

**Jekyll PDF** will check for your current layout suffixed with `_pdf` e.g. if you're using a layout called `post`, it will look for `_layouts/post_pdf.html`, falling back to your default PDF layout (usually `_layouts/pdf.html`). 

To override this behaviour, add the `pdf_layout` variable to your page's YAML front-matter. For example:

```yaml
pdf_layout: my_custom_pdf_layout
```

## Partials (Header, Footer & Cover Page)

We'll automatically look for all partials in `_includes` directory, e.g. `header_html: pdf_header.html` will tell Jekyll PDF use `_includes/pdf_header.html`. 

Please note that wkhtmltopdf requires all partials to be valid HTML documents for example:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/css/bootstrap.css">
</head>
<body>
  Page {{ page.pdf.page }} of {{ page.pdf.topage }}
</body>
</html>
```

### Supported header & footer variables

| Liquid                         | Description                                                 |
|--------------------------------|-------------------------------------------------------------|
| `{{ page.pdf.page }}`          | Replaced by the number of the pages currently being printed |
| `{{ page.pdf.topage }}`        | Replaced by the number of the last page to be printed       |
| `{{ page.pdf.section }}`       | Replaced by the content of the current h1 tag               |
| `{{ page.pdf.subsection }}`    | Replaced by the content of the current h2 tag               |
| `{{ page.pdf.subsubsection }}` | Replaced by the content of the current h3 tag               |


## Troubleshooting

### Images aren't displaying in the PDF

If your images aren't displaying in the PDF, this is most likely due to the fact that wkhtmltopdf doesn't know where to look. Try prefixing your image URLs with `file://{{ site.dest }}`.  
For asset URLs in CSS files we recommend creating a separate CSS file overriding the URLs with the prefix mentioned above.

---

## To Do

- Remove dependencies for ActiveSupport & PDFKit
- Write tests (rspec)
- Package default PDF layout file in Gem
- Support layouts in partials