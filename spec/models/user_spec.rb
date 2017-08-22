require 'rails_helper'

RSpec.describe User do
  it { should validate_presents _of :email }
  it { should validate_presents _of :password }
end