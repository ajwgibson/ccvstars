require 'rails_helper'

RSpec.describe HasSortableName, type: :concern do

  class WithName
    include ActiveModel::Model
    include HasSortableName
    attr_accessor :first_name, :last_name
  end

  describe '#name' do
    it 'returns last_name, first_name' do
      m = WithName.new(:first_name => 'John', :last_name => 'Watson')
      expect(m.name).to eq('Watson, John')
    end
    context 'when there is no last_name' do
      it 'returns the first_name' do
        m = WithName.new(:first_name => 'John')
        expect(m.name).to eq('John')
      end
    end
    context 'when there is no first_name' do
      it 'returns the last_name' do
        m = WithName.new(:last_name => 'Watson')
        expect(m.name).to eq('Watson')
      end
    end
    context 'when there is no first_name or last_name' do
      it 'returns an empty string' do
        m = WithName.new
        expect(m.name).to eq('')
      end
    end
  end

end