FactoryGirl.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    user { create(:user) }
    title
    body "Question body"
  end

  factory :invalid_question, class: "Question" do
    user nil
    title nil
    body nil
  end
end
