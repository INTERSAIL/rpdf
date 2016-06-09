require "rpdf/version"
require "savon"
require 'rpdf/concerns/models/xml_serializable'

module Intersail
  module Rpdf
    class ZapPdfClient

      def initialize(address)
        @url = address
        @ws = Savon.client(wsdl: "#{address}?wsdl")
      end

      def url
        @url
      end

      def make_pdf_with_local_file(templateFile, data, options = {})
        templateData = Base64.encode64(File.read(templateFile))

        response = @ws.call(:make_pdf_with_xml, message: { data: templateData, xmlTags: data.to_xml(options) })

        return nil unless response

        pdfData = response.body[:make_pdf_with_xml_response][:make_pdf_with_xml_result]

        Base64.decode64(pdfData)
      end

      def get_template_tags(templateFile)
        templateData = Base64.encode64(File.read(templateFile))

        response = @ws.call(:get_template_tags, message: { data: templateData })

        return nil unless response

        tags = response.body[:get_template_tags_response][:get_template_tags_result]
        tags
      end
    end
  end
end
