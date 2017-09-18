require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should define_enum_for(:vote_type).with(positive: 1, negative: -1) }
end
