require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect(Question.new(body: 'body text')).to_not be_valid
  end

  it 'validates presence of body' do
    expect(Question.new(title: 'title text')).to_not be_valid
  end
end
