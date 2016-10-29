require 'test_helper'

class RecordACallTest < ActionDispatch::IntegrationTest
  before do
    Capybara.current_driver = :poltergeist
    @user = create :user
    log_in_as @user

    4.times do |i|
      pt = create :patient, name: "Patient #{i}",
                            primary_phone: "123-123-123#{i}",
                            created_by: @user
      create :pregnancy, patient: pt
    end

    @user.add_patient Patient.find_by(name: 'Patient 0')
    @user.add_patient Patient.find_by(name: 'Patient 1')
    @user.add_patient Patient.find_by(name: 'Patient 2')
    @user.add_patient Patient.find_by(name: 'Patient 3')
  end

  after do
    Capybara.use_default_driver
    Patient.destroy_all
  end

  describe 'Home Page Call Action' do
    before do
      visit '/'
    end

    it 'should update Call Lists' do
      find("a[href='#call-123-123-1231']").click
      wait_for_ajax

      within :css, '#call-123-123-1231' do
        find('a', text: "I left a voicemail for the patient").click
        click_link "I left a voicemail for the patient"
        # after click modal is still up

      end
      wait_for_page_to_load
      wait_for_ajax

      within :css, '#call_list_content' do
        assert has_css? 'tr', count: 3
      end

      within :css, '#completed_calls_content' do
        assert has_css? 'tr', count: 1
      end
    end


  end

  describe 'Edit Page Call Action' do
    before do
      visit '/'
      find('a', text: 'Patient 2').click
      wait_for_page_to_load
      find('a', text: 'Call Log').click
      wait_for_ajax
      find("a[href='#call-123-123-1232']").click
      wait_for_ajax
    end

    # modal is not displaying, display: block should be up
    # dialing correct number
    it 'should update Call Log' do
      find
      puts page.body
    end
  end

  private

  def wait_for_page_to_load
    has_text? 'Submit pledge'
  end

end
