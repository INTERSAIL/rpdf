require "rpdf/version"
require "savon"

module Intersail
  module Rpdf
    class ZapPdfClient

      def initialize(address)
        @ws = Savon.client(wsdl: "#{address}?wsdl")
      end

      def make_pdf_with_local_file(templateFile, data, options = {} )
        include_options = options.delete(:include) || []

        templateData = Base64.encode64(File.read(templateFile))

        response = @ws.call(:make_pdf_with_xml, message: { data: templateData, xmlTags: data.to_xml(include: include_options) })

        return nil unless response

        pdfData = response.body[:make_pdf_with_xml_response][:make_pdf_with_xml_result]

        Base64.decode64(pdfData)
      end
    end
  end
end