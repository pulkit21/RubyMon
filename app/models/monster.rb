class Monster < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  MONSTER_TYPE =  %w[fire water earth electric wind]
  LIMIT_PER_TEAM = 3
  LIMIT_PER_USER = 20

  validates :name, presence: true
  validates :monster_type, inclusion: MONSTER_TYPE
  validate :check_limit_per_team, on: [:create, :update], if: -> { team_id_changed? && team_id }
  validate :check_limit_per_user, on: :create

  #######
  private
  #######


  def check_limit_per_team
    errors.add(:monsters, "#{LIMIT_PER_TEAM} monsters allowed per team") if team && team.monsters.count >= LIMIT_PER_TEAM
  end

  def check_limit_per_user
    errors.add(:monsters, "Cannot create more than #{LIMIT_PER_USER} teams per user") if user && user.monsters.count >= LIMIT_PER_USER
  end


end
