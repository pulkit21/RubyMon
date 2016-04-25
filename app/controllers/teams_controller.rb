class TeamsController < ApplicationController
  authorize_resource
  before_action :set_team, only: [:show, :update, :destroy]

  def index
    @teams = current_user.teams
    render :index, status: 200
  end

  def create
    @team = current_user.teams.new(team_params)
    if @team.save
      render :show, status: 201
    else
      render json: @team.errors, status: 422
    end
  end

  def show
    render :show, status: 200
  end

  def update
    if @team.update(team_params)
      render :show, status: 200
    else
      render json: @team.errors, status: 422
    end
  end

  def destroy
    @team.destroy
    head :no_content
  end


  #######
  private
  #######

  def set_team
    if current_user
      @team = current_user.teams.find(params[:id])
    else
      @team = Team.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name)
  end


end
