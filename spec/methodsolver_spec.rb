require 'spec_helper'

describe Methodsolver do

  it 'has a version number' do
    expect(Methodsolver::VERSION).not_to be nil
  end

  it 'does something useful' do
    object, found = Methodsolver.call { 'lettuce'.foo == 7 }

    expect(found).to include :size
    expect(found).to include :length
  end

end
