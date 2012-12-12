# What is text_normalizer-ja

Japanese text normalizer.

## Installation

Add this line to your application's Gemfile:

    gem 'text_normalizer-ja'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text_normalizer-ja

## Usage

    require 'text_normalizer-ja'

    string_normalizer = TextNormalizer[:ja].for_string { narrow >> downcase }
    puts string_normalizer['ＡＢＣ'] # => "abc"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
