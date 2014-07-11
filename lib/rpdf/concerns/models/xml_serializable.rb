module Intersail::Rpdf::XmlSerializable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :xml_include_fields
  end


  module ClassMethods
    def xml_include(*fields)
      self.xml_include_fields = fields
    end
  end

  def to_xml(options = {})
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

    super_options = options.merge({include: include})

    super(super_options)
  end


end