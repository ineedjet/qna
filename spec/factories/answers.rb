FactoryGirl.define do
  sequence :body do |n|
    "MyText #{n}"
  end

  factory :answer do
    question { create(:question) }
    body
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
