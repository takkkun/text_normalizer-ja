module TextNormalizer
  module Ja
    {:string => :String, :morphemes => :Morphemes}.each do |normalizer_name, const_name|
      require "text_normalizer/ja/#{normalizer_name}"
      normalizer = const_get(const_name)
      self.class.__send__(:define_method, "for_#{normalizer_name}") { |&build| normalizer.build(&build) }
    end
  end
end
