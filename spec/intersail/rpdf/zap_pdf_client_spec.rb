require 'spec_helper'

require 'active_model'

describe Intersail::Rpdf::ZapPdfClient do
  before(:all) do
    @url = 'http://ced-sisi/WSZapPdf/ZapPdfService.asmx'
    @client = Intersail::Rpdf::ZapPdfClient.new(@url)
    @template1 = 'spec/template1.odt'
    @template2 = 'spec/template2.odt'
  end

  it 'should set url' do
    expect(@client.url).to eq(@url)
  end

  context 'single tag' do
    before do
      @node = @client.get_template_tags(@template2)
    end

    it 'should build node' do
      expect(@node).to_not be nil

      expect(@node.name).to be nil
      expect(@node).to have_children

      expect(@node.children.length).to eq 1

      expect(@node.children[0].name).to eq 'name'
      expect(@node.children[0]).to_not have_children
    end

    it 'should behave like Hash' do
      expect(@node[:name]).to be nil
      expect(@node[:childs]).to_not be nil
      expect(@node[:childs][:tag_node]).to_not be nil

      expect(@node[:childs][:tag_node]).to be_kind_of Hash

      expect(@node[:childs][:tag_node][:name]).to eq 'name'
      expect(@node[:childs][:tag_node][:childs]).to be nil
    end
  end

  context 'array tag' do
    before do
      @node = @client.get_template_tags(@template1)
    end

    it 'should create tags array' do
      expect(@node).to_not be nil

      tags = TagArray.new(@node)

      expect(tags.array.length).to eq 4

      expect(tags.array[0]).to eq 'amounts.value'cd ..

      expect(tags.array[1]).to eq 'amounts.currency'
      expect(tags.array[2]).to eq 'name'
      expect(tags.array[3]).to eq 'surname'
    end

    it 'should read node' do
        expect(@node).to_not be nil

        expect(@node.name).to be nil
        expect(@node).to have_children

        expect(@node.children.length).to eq 3

        expect(@node.children[0].name).to eq 'amounts'
        expect(@node.children[0]).to have_children

        expect(@node.children[0].children.length).to eq 2

        expect(@node.children[0].children[0].name).to eq 'value'
        expect(@node.children[0].children[0]).to_not have_children

        expect(@node.children[0].children[1].name).to eq 'currency'
        expect(@node.children[0].children[1]).to_not have_children

        expect(@node.children[1].name).to eq 'name'
        expect(@node.children[1]).to_not have_children

        expect(@node.children[2].name).to eq 'surname'
        expect(@node.children[2]).to_not have_children
    end
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

    pdf = @client.make_pdf_with_local_file(@template1, person)

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
      Amount.new(value:'100,00',currency:'EUR'),
      Amount.new(value:'20,30',currency:'USD')
    ]

    pdf = @client.make_pdf_with_local_file(@template1, person)

    expect(pdf).to_not be nil

    File.open('template2.pdf', 'w'){|f| f.write(pdf)}
  end
end
