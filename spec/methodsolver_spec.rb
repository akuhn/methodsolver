require 'spec_helper'

describe Methodsolver do

  it 'has a version number' do
    expect(Methodsolver::VERSION).not_to be nil
  end

  it 'should pass README.md example' do
    found = Methodsolver.call {
      h = { a: 1, bunny: 2, c: 3 }
      h.______(:bunny)
      h.keys == [:a, :c]
    }
    expect(found).to include :delete
  end

  it 'should fail when no block given' do
    expect {
      Methodsolver.call
    }.to raise_error ArgumentError, 'no block given'
  end

  it 'should fail when no placeholder given' do
    expect {
      Methodsolver.call { 3 + 4 == 7 }
    }.to raise_error ArgumentError, 'no missing method found'
  end

  let(:words) do
    %w(the quick brown fox jumps over the lazy dog)
  end

  it 'should find methods without arguments' do
    found = Methodsolver.call {
      words.dup.foo == 'the'
    }
    expect(found).to include :first
  end

  it 'should find methods defined by a module' do
    names = Methodsolver.methods_for(1..10)
    expect(names).to include :take_while # defined in Enumerable
  end

  it 'should find methods defined by a class' do
    names = Methodsolver.methods_for(1..10)
    expect(names).to include :each # defined in Range
  end

  it 'should find methods with an argument' do
    found = Methodsolver.call {
      words.dup.foo('the') == 2
    }
    expect(found).to include :count
  end

  it 'should find methods with many arguments' do
    found = Methodsolver.call {
      words.dup.foo(1, 2, 4) == %w(quick brown jumps)
    }
    expect(found).to include :values_at
  end

  it 'should find methods with block argument' do
    found = Methodsolver.call {
      words.dup.foo(&:size) == [3, 5, 5, 3, 5, 4, 3, 4, 3]
    }
    expect(found).to include :collect
  end

  it 'should find methods that raise errors' do
    found = Methodsolver.call {
      begin
        words.dup.freeze.foo
        false
      rescue RuntimeError
        true
      end
    }
    expect(found).to include :shift
    expect(found).to_not include :take
  end

  it 'should find singleton methods' do
    example = Object.new
    def example.singleton_method; end
    names = Methodsolver.methods_for(example)
    expect(names).to include :singleton_method
  end

  it 'should find methods on numbers' do
    found = Methodsolver.call { 3.foo(4) == 7 }
    expect(found).to include :+
  end

  it 'should blacklist setters' do
    example = Struct.new(:example).new(42)
    names = Methodsolver.methods_for(example)
    expect(names).to_not include :example=
  end

  it 'should blacklist dangerous methods' do
    names = Methodsolver.methods_for('example')
    expect(names).to_not include :reverse!
  end

end
