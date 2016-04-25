class Team < ActiveRecord::Base
  # Specify the team limit.
  TEAM_LIMIT_PER_USER = 3

  belongs_to :user
  validates :name, presence: true
  validate :check_the_team_limit_per_user, on: :create

  #######
  private
  #######

  # To check the number of teams per user.
  def check_the_team_limit_per_user
    errors.add(:teams, "Cannot create more than #{TEAM_LIMIT_PER_USER} per user") if user && user.teams.count >= TEAM_LIMIT_PER_USER
  end

end
