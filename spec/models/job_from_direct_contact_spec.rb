require 'spec_helper'

describe JobFromDirectContact do
  context 'validations' do
    it { should validate_presence_of(:hourly_rate) }
    it { ensure_inclusion_only_of(JobFromDirectContact, :rate_type, ['hourly']) }
  end
end
