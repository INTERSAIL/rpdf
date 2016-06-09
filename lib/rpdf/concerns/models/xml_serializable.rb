require 'active_support/all'

module Intersail
  module Rpdf
    module XmlSerializable

      extend ActiveSupport::Concern

      included do
        cattr_accessor :xml_include_fields
        cattr_accessor :xml_methods_fields

        self.xml_include_fields = []
        self.xml_methods_fields = []
      end


      module ClassMethods
        def xml_include(*fields)
          fields.each { |f| self.xml_include_fields << f }
        end
        def xml_methods(*fields)
          fields.each { |f| self.xml_methods_fields << f }
        end
      end

      def to_xml(options = {})
        method_options = options.delete(:methods) || []
        include_options = options.delete(:include) || []
        exclude_options = options.delete(:exclude)

        if exclude_options == :all
          include = []
        else
          include = self.class.xml_include_fields << include_options
          include = include.flatten.compact.uniq

          if exclude_options
            if exclude_options.kind_of?(Array)
              exclude_options.each { |e| include.delete(e) }
            else
              include.delete(exclude_options)
            end
          end
        end

        methods = self.class.xml_methods_fields << method_options
        methods = methods.flatten.compact.uniq

        super_options = options.merge({include: include, methods: methods})

        super(super_options)
      end

    end
  end
end
