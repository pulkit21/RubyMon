require 'rails_helper'

RSpec.describe Team, type: :model do

  it "should save team with valid attributes" do
    user = create(:user)
    team = build(:team, name: 'Team1', user: user)
    expect(team).to be_valid
  end

  it "should not save team without name" do
    team = build(:team, name: '')
    expect(team).to be_invalid
  end

  it "should not save team without user" do
    team = build(:team, name: "Team1", user_id: '')
    expect(team).to be_invalid
  end

  it "should not save team due to the limit per user" do
    user = create(:user)
    [*1..3].each do |f|
      @team = create(:team, name: "Team#{f}", user: user)
    end
    expect(@team).to be_valid
  end



end
