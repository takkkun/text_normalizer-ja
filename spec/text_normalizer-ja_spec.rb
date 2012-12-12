require 'text_normalizer-ja'

describe TextNormalizer::Ja do
  it 'is registered to multilang as Japanese' do
    TextNormalizer.slot.should be_exists('Japanese')
  end

  it 'requires text_normalizer/ja at first using' do
    Multilang.should_receive(:require).with('text_normalizer/ja')
    TextNormalizer['Japanese']
  end
end
