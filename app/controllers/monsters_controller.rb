class MonstersController < ApplicationController
  authorize_resource
  before_action :set_monster, only: [:show, :update, :destroy]

  def index
    @monsters = current_user.monsters.includes(:team).references(:teams)
    @sort_dir = params[:sort_dir] == "desc" ? "desc" : "asc"
    if params[:sort_col] == "weakness"
      @monsters =  @monsters.sort { |a, b| @sort_dir == "asc" ? a <=> b : b <=> a }
    else
      @monsters = @monsters.order("#{params[:sort_col]}": :"#{@sort_dir}")
    end
    render :index, status: 200
  end

  def create
    @monster =  current_user.monsters.new(monster_params)
    if @monster.save
      render :show, status: 201
    else
      render json: @monster.errors, status: 422
    end
  end

  def show
    render :show, status: 200
  end

  def update
    if @monster.update(monster_params)
      render :show, status: 200
    else
      render json: @monster.errors, status: 422
    end
  end


  def destroy
    @monster.destroy
    head :no_content
  end


  #######
  private
  #######

  def set_monster
    if current_user
      @monster = current_user.monsters.find(params[:id])
    else
      @monster = Monster.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def monster_params
    params.require(:monster).permit(:name, :power, :monster_type, :team_id)
  end
end
