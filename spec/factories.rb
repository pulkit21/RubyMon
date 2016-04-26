FactoryGirl.define do

  factory :user do
    sequence(:uid) { |n| "10154051716#{n}73914" }
    sequence(:email) { |n| "user#{n}@example.com" }
    provider "facebook"
    password "password"
  end


  factory :team do |f|
    sequence(:name) { |n| "Team#{n}" }
    user { User.last}
  end

  factory :monster do
    sequence(:name) { |n| "Monster#{n}" }
    user { User.last}
    team { User.last.teams.last}
    power ["fire", "water", "earth", "electric", "wind"].sample
    monster_type ["fire", "water", "earth", "electric", "wind"].sample

  end

end
