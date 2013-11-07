FactoryGirl.define do
  factory :job do
    client
    programmer
    rate 50
    availability 'full-time'
    sequence :name do |n|
      "Test Job #{n}"
    end
    before :create do |instance|
      instance.started_at = 1.day.ago if (instance.running? || instance.finished? || instance.disabled?)
      instance.finished_at = 1.day.ago if (instance.finished? || instance.disabled?)
    end
  end
end
