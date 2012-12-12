require 'text_normalizer-ja/version'
require 'multilang'

module TextNormalizer
  module Ja
    Multilang.register self, :as => :ja, :with => 'text_normalizer/ja'
  end
end
