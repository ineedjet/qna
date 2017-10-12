FactoryGirl.define do
   factory :oauth_application, class: Doorkeeper::Application do
     name 'test'
     uid '123456'
     redirect_uri "urn:ietf:wg:oauth:2.0:oob"
     secret '654321'
   end
end