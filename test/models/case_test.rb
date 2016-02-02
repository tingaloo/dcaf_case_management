require 'test_helper'

class CaseTest < ActiveSupport::TestCase
  it 'should do a thing' do 
    sample_case = build :case
    assert_equal 'DC', sample_case.line
  end
end
