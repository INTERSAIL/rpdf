# Rpdf

Interface to Ws-ZapPdf service.

## Installation

Add this line to your application's Gemfile:

    gem 'rpdf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rpdf

## Usage

###To send a PDF in real time to the client using some data and a local file as a template:
 
    zappdf = Intersail::Rpdf::ZapPdfClient.new('[my-zappdf-service-url]')
    pdf = zappdf.make_pdf_with_local_file('[my-local-template-file]', @data_objects_for_tags)
    send_data(pdf, content_type: 'application/pdf', disposition: 'inline') 

## Contributing

1. Fork it ( https://github.com/INTERSAIL/rpdf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
