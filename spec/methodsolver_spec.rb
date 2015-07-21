require 'spec_helper'

describe Methodsolver do

  it 'has a version number' do
    expect(Methodsolver::VERSION).not_to be nil
  end

  it 'should pass README.md example' do
    object, found = Methodsolver.call { 'lettuce'.foo == 7 }

    expect(found).to include :size
    expect(found).to include :length
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
    object, found = Methodsolver.call {
      words.dup.foo == 'the'
    }
    expect(found).to include :first
  end

  it 'should find methods defined in a module' do
    object, found = Methodsolver.call {
      (8...15).foo == 7
    }
    expect(found).to include :count
  end

  it 'should find methods defined in a class' do
    object, found = Methodsolver.call {
      (8...15).foo == 15
    }
    expect(found).to include :end
  end

  it 'should find methods with an argument' do
    object, found = Methodsolver.call {
      words.dup.foo('the') == 2
    }
    expect(found).to include :count
  end

  it 'should find methods with many arguments' do
    object, found = Methodsolver.call {
      words.dup.foo(1, 2, 4) == %w(quick brown jumps)
    }
    expect(found).to include :values_at
  end

  it 'should find methods with block argument' do
    object, found = Methodsolver.call {
      words.dup.foo(&:size) == [3, 5, 5, 3, 5, 4, 3, 4, 3]
    }
    expect(found).to include :collect
  end

  it 'should find methods that raise errors' do
    object, found = Methodsolver.call {
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
    object = Object.new
    def object.singleton_method; 42; end
    _, found = Methodsolver.call {
      object.foo == 42
    }
    expect(found).to include :singleton_method
  end

  it 'should find methods on numbers' do
    object, found = Methodsolver.call { 3.foo(4) == 7 }
    expect(found).to include :+
  end

end
