module Jekyll
  module PDF
    module Helper
      def fix_relative_paths
        if site.baseurl != nil
	  output.gsub!(/(href|src)=(['"])#{Regexp.escape(site.baseurl)}\/([^\/"']([^\"']*|[^"']*))?['"]/, "\\1=\\2file://#{site.source}/\\3\\2") if output != nil
	else
          output.gsub!(/(href|src)=(['"])\/([^\/"']([^\"']*|[^"']*))?['"]/, "\\1=\\2file://#{site.source}/\\3\\2") if output != nil
	end
      end
    end
  end
end
