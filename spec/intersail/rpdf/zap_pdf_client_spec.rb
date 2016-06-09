require 'spec_helper'

require 'active_model'

describe Intersail::Rpdf::ZapPdfClient do
  before(:all) do
    @url = 'http://ced-sisi/WSZapPdf/ZapPdfService.asmx'
    @client = Intersail::Rpdf::ZapPdfClient.new(@url)
  end

  it 'should instance with an url' do
    expect(@client.url).to eq(@url)
  end

  it 'should create a pdf from a hash' do
    person = {
      name: 'Paolino',
      surname: 'Paperino',
      amounts: [
        {value: "100,00", currency: 'EUR'},
        {value: "20,30", currency: 'USD'},
      ]
    }

    template = 'spec/template1.odt'

    pdf = @client.make_pdf_with_local_file(template, person)

    expect(pdf).to_not be nil

    File.open('template1.pdf', 'w'){|f| f.write(pdf)}
  end

  it 'should create a pdf from an object' do
    class Person
      include ActiveModel::Model
      include ActiveModel::Serializers::Xml
      attr_accessor :name, :surname, :amounts

      def attributes=(hash)
        hash.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
      def attributes
        instance_values
      end
    end

    class Amount
      include ActiveModel::Model
      include ActiveModel::Serializers::Xml
      attr_accessor :value, :currency

      def attributes=(hash)
        hash.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
      def attributes
        instance_values
      end
    end

    person = Person.new(name:'Paolino',surname:'Paperino')
    person.amounts = [
      Amount.new(value:'100.00',currency:'EUR'),
      Amount.new(value:'20,30',currency:'USD')
    ]

    template = 'spec/template1.odt'

    pdf = @client.make_pdf_with_local_file(template, person)

    expect(pdf).to_not be nil

    File.open('template2.pdf', 'w'){|f| f.write(pdf)}
  end
end
