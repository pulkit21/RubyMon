require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  let(:valid_user) { create(:user) }

  let(:valid_attributes) {
    {
      name: "Team1",
      user: valid_user
    }
  }

  let(:invalid_attributes) {
    {
      name: "Team1"
      # No user
    }
  }

  let(:valid_session) { {} }


  before(:each) do
    request.format = :json
    login_user(valid_user, request)
  end

  describe "GET #index" do
    it "assigns all teams as @teams" do
      team = create(:team, user: valid_user)
      get :index

      expect(assigns(:teams)).to eq([team])
    end
  end


  describe "GET #show" do
    context "with known team id" do
      it "assigns the requested team as @team" do
        team = create(:team, user: valid_user)
        get :show, {:id => team.to_param}
        expect(assigns(:team)).to eq(team)
      end
    end

    context "with unknown team id" do
      it "renders not_found template" do
        get :show, {:id => 1234}
        expect(response.status).to eq(404)
      end
    end
  end


  describe "POST #create" do
    context "with valid params" do
      # render views to check if the response was the created team
      render_views

      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes }
        }.to change(Team, :count).by(1)
      end

      it "assigns the newly created team as @team" do
        post :create, {:team => valid_attributes}
        expect(assigns(:team)).to be_a(Team)
        expect(assigns(:team)).to be_persisted
      end

      it "show newly created team" do
        post :create, {:team => valid_attributes}
        expect(response).to render_template(:show)
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["id"]).to eq(Team.last.id)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => new_attributes}, valid_session
        team.reload
      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end
    end

    context "with invalid params" do
      it "assigns the team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => invalid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested team" do
      team = Team.create! valid_attributes
      expect {
        delete :destroy, {:id => team.to_param}, valid_session
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Team.create! valid_attributes
      delete :destroy, {:id => team.to_param}, valid_session
    end
  end

end
