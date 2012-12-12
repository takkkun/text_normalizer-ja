require 'text_normalizer/ja'

describe TextNormalizer::Ja, '.#for_string' do
  it "calls #{described_class}::String.#build with the block" do
    block = lambda {}
    TextNormalizer::Ja::String.should_receive(:build).with(&block)
    described_class.for_string(&block)
  end

  it "returns the return value from #{described_class}::String.#build" do
    TextNormalizer::Ja::String.stub(:build => 'value from build')
    described_class.for_string {}.should == 'value from build'
  end
end

describe TextNormalizer::Ja, '.#for_morphemes' do
  it "calls #{described_class}::Morphemes.#build with the block" do
    block = lambda {}
    TextNormalizer::Ja::Morphemes.should_receive(:build).with(&block)
    described_class.for_morphemes(&block)
  end

  it "returns the return value from #{described_class}::Morphemes.#build" do
    TextNormalizer::Ja::Morphemes.stub(:build => 'value from build')
    described_class.for_morphemes {}.should == 'value from build'
  end
end
