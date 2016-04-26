require 'rails_helper'

RSpec.describe Monster, type: :model do

  it "should save monster with valid attributes" do
    user = create(:user)
    team = create(:team, name: 'Team1', user: user)
    monster = build(:monster, name: "Monster1", power: "fire", monster_type: "fire", user: user)
    expect(monster).to be_valid
  end

  it "should not save monster without name" do
    user = create(:user)
    team = create(:team, name: 'Team1', user: user)
    monster = build(:monster, name: '')
    expect(monster).to be_invalid
  end

  it "should not save monster without type" do
    user = create(:user)
    team = create(:team, name: 'Team1', user: user)
    monster = build(:monster, monster_type: '')
    expect(monster).to be_invalid
  end

  it "should save team due to the limit per user" do
    user = create(:user)
    team = create(:team, name: 'Team1', user: user)
    [*1..3].each do |f|
      monster_type = ["fire", "water", "earth", "electric", "wind"].sample
      @monster = create(:monster, name: "Monster1", monster_type: monster_type, power: monster_type, team: team)
    end
    expect(@monster).to be_valid
  end

end
