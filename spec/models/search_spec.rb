require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    it "gets search in all" do
      expect(ThinkingSphinx).to receive(:search).with('test')
      Search.find('test', 'All')
    end

    %w(Answer Question User Comment).each do |model|
      it "gets #{model} in 'for' param" do
        expect(model.classify.constantize).to receive(:search).with('test')
        Search.find('test', model)
      end
    end
  end
end
