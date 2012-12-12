require 'spec_helper'
require 'text_normalizer/ja/normalizer'

describe TextNormalizer::Ja::Normalizer do
  before do
    @class = sample_normalizer
  end

  it 'adds #order to the class' do
    @class.should be_respond_to(:order)
  end

  it 'adds #filters to the class' do
    @class.should be_respond_to(:filters)
  end

  it 'adds #define to the class' do
    @class.should be_respond_to(:define)
  end

  it 'adds #build to the class' do
    @class.should be_respond_to(:build)
  end
end

describe TextNormalizer::Ja::Normalizer::ClassMethods, '#order' do
  it 'returns an empty array by default' do
    order = sample_normalizer.order
    order.should be_an(Array)
    order.should be_empty
  end
end

describe TextNormalizer::Ja::Normalizer::ClassMethods, '#filters' do
  it 'returns an empty hash by default' do
    filters = sample_normalizer.filters
    filters.should be_an(Hash)
    filters.should be_empty
  end
end

describe TextNormalizer::Ja::Normalizer::ClassMethods, '#define' do
  before do
    @normalizer = sample_normalizer
  end

  it 'defines a filter' do
    identify = lambda { |x| x }
    @normalizer.define(:identify, &identify)
    @normalizer.order.should be_include(:identify)
    @normalizer.filters.should be_key(:identify)
    @normalizer.filters[:identify].should == identify
  end

  it 'adds name of the filter to #order in number order' do
    @normalizer.define(:downcase, &:downcase)
    @normalizer.define(:reverse, &:reverse)
    @normalizer.order.should == [:downcase, :reverse]
  end

  it 'extends the filter to composable' do
    identify = lambda { |x| x }
    @normalizer.define(:identify, &identify)
    filter = @normalizer.filters[:identify]
    identify.should_not be_respond_to(:<<)
    identify.should_not be_respond_to(:>>)
    filter.should be_respond_to(:<<)
    filter.should be_respond_to(:>>)
  end
end

describe TextNormalizer::Ja::Normalizer::ClassMethods, '#build' do
  before do
    @normalizer = sample_normalizer
  end

  it 'calls the block in building scope as defined by the class' do
    TextNormalizer::Ja::Normalizer::BuildingScope.stub(:new).with(@normalizer).and_return('building scope')
    scope = nil
    @normalizer.build { scope = self; lambda {} }
    scope.should == 'building scope'
  end

  it 'returns the normalizer got from the block' do
    normalizer = lambda {}
    @normalizer.build { normalizer }.should == normalizer
  end

  it 'raises ArgumentError if a block does not give' do
    lambda { @normalizer.build }.should raise_error(ArgumentError, 'need a block')
  end

  it 'raises ArgumentError if the block does not return a normalizer' do
    lambda { @normalizer.build { nil } }.should raise_error(ArgumentError, 'did not get a normalizer from the block')
  end
end

describe TextNormalizer::Ja::Normalizer::BuildingScope, '#all' do
  it 'returns the normalizer with all filters in number order' do
    normalizer = sample_normalizer
    normalizer.define(:add1) { |s| "{1 => #{s}}" }
    normalizer.define(:add2) { |s| "{2 => #{s}}" }
    normalizer.define(:add3) { |s| "{3 => #{s}}" }
    described_class.new(normalizer).all['s'].should == '{3 => {2 => {1 => s}}}'
  end
end

describe TextNormalizer::Ja::Normalizer::BuildingScope, '#f' do
  before do
    @building_scope = described_class.new(sample_normalizer)
  end

  it 'returns the block' do
    identify = lambda { |x| x }
    filter = @building_scope.f(&identify)
    filter.should == identify
  end

  it 'extends the block to composable' do
    identify = lambda { |x| x }
    filter = @building_scope.f(&identify)
    identify.should_not be_respond_to(:<<)
    identify.should_not be_respond_to(:>>)
    filter.should be_respond_to(:<<)
    filter.should be_respond_to(:>>)
  end
end

describe TextNormalizer::Ja::Normalizer::BuildingScope, '#method_missing' do
  it 'returns the filter that associated to the name' do
    identify = lambda { |x| x }
    normalizer = sample_normalizer
    normalizer.define(:identify, &identify)
    building_scope = described_class.new(normalizer)
    building_scope.identify.should == identify
  end

  it 'raises NameError if the filter does not defined' do
    normalizer = sample_normalizer
    building_scope = described_class.new(normalizer)
    lambda { building_scope.identify }.should raise_error(NameError, "identify filter is not defined in #{normalizer}")
  end
end

describe TextNormalizer::Ja::Normalizer::Composable, '#<<' do
  it 'composes the functions (self o f)(x)' do
    add1 = f { |s| "{1 => #{s}}" }
    add2 = f { |s| "{2 => #{s}}" }
    (add1 >> add2)['s'].should == '{2 => {1 => s}}'
  end
end

describe TextNormalizer::Ja::Normalizer::Composable, '#>>' do
  it 'composes the functions (g o self)(x)' do
    add1 = f { |s| "{1 => #{s}}" }
    add2 = f { |s| "{2 => #{s}}" }
    (add1 << add2)['s'].should == '{1 => {2 => s}}'
  end
end
