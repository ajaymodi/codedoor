require 'spec_helper'

describe ApplicationHelper do

  describe 'model_error_message' do
    it 'return blank string if model\'s attribute is valid' do
      programmer = FactoryGirl.create(:programmer)
      model_error_message(programmer, :visibility).should eq('')
    end

    it 'returns a sentence if model\'s attribute is invalid' do
      programmer = FactoryGirl.create(:programmer)
      programmer.visibility = 'invalid'
      programmer.valid?
      model_error_message(programmer, :visibility).should eq('Visibility must be selected.')
    end

    it 'returns error messages from both validates and other validation methods' do
      resume_item = FactoryGirl.create(:resume_item)
      resume_item.year_started = 1801
      resume_item.year_finished = 1800
      resume_item.valid?
      model_error_message(resume_item, :year_started).should eq('Year started must be greater than 1900 and must be before the year finished.')
    end
  end

  context 'client_rate_text' do
    it 'should show rate for full-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'full-time', rate: 100)
      client_rate_text(programmer).should eq('$900 / day')
    end

    it 'should show rate for part-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'part-time', rate: 100)
      client_rate_text(programmer).should eq('$112.50 / hour')
    end

    it 'should show rate for jobs' do
      job = FactoryGirl.create(:job, availability: 'part-time', rate: 100)
      client_rate_text(job).should eq('$112.50 / hour')
    end

    it 'should not show rate for unavailable programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'unavailable', rate: 100)
      client_rate_text(programmer).should eq('Unavailable')
    end
  end

  context 'programmer_rate_text' do
    it 'should show rate for full-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'full-time', rate: 50)
      programmer_rate_text(programmer).should eq('$400 / day')
    end

    it 'should show rate for part-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'part-time', rate: 50)
      programmer_rate_text(programmer).should eq('$50 / hour')
    end

    it 'should show rate for jobs' do
      job = FactoryGirl.create(:job, availability: 'part-time', rate: 50)
      programmer_rate_text(job).should eq('$50 / hour')
    end

    it 'should not show rate for unavailable programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'unavailable', rate: 50)
      programmer_rate_text(programmer).should eq('Unavailable')
    end
  end

end
