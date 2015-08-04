FactoryGirl.define do

  factory :clearance_batch do
    created_at do
      from = Time.now.to_f
      to   = 2.years.from_now.to_f
      Time.at(from + rand * (to - from))
    end
    updated_at do
      from = Time.now.to_f
      to   = 2.years.from_now.to_f
      Time.at(from + rand * (to - from))
    end
  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
  end

  factory :style do
    wholesale_price 55
  end

end
