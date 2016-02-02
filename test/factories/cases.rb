FactoryGirl.define do
  factory :case do
    line 'DC'
    initial_call_date { 2.months.ago }   
  end
end
