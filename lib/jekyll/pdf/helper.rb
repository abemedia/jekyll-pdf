module Jekyll
  module PDF
    module Helper
      def fix_relative_paths
        prefix = "file://#{site.dest}/"
        output = output.gsub(/(href|src)=(['"])\/([^\/"']([^\"']*|[^"']*))?['"]/, "\\1=\\2#{prefix}\\3\\2")
      end
    end
  end
end
