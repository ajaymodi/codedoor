require 'spec_helper'

describe JobFromApplication do
  context 'validations' do
    it { should validate_presence_of(:job_listing_id) }
    it { ensure_inclusion_only_of(JobFromApplication, :rate_type, ['hourly', 'fixed_price']) }

    # TODO: FIX TESTS
    # it 'should require hourly_rate if the rate_type is hourly' do
    #   job = FactoryGirl.create(:job_from_application, rate_type: 'hourly')
    #   job.hourly_rate = nil
    #   job.valid?.should be_false
    #   job.errors[:hourly_rate].should eq(['can\'t be blank'])
    #   job.hourly_rate = 50
    #   job.valid?.should be_true
    # end

    # it 'should require hourly_rate if the rate_type is fixed_price' do
    #   job = FactoryGirl.create(:job_from_application, rate_type: 'fixed_price', fixed_rate: 50)
    #   job.fixed_rate = nil
    #   job.valid?.should be_false
    #   job.errors[:fixed_rate].should eq(['can\'t be blank'])
    #   job.fixed_rate = 50
    #   job.valid?.should be_true
    # end
  end
end
