require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of(:user).with_message('must exist') }
end
