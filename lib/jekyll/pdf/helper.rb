module Jekyll
  module PDF
    module Helper
      def fix_relative_paths
        output.gsub!(/(href|src)=(['"])\/([^\/"']([^\"']*|[^"']*))?['"]/, "\\1=\\2file://#{site.dest}/\\3\\2") unless output.nil?
      end
    end
  end
end
