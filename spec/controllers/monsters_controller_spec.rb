require 'rails_helper'

RSpec.describe MonstersController, type: :controller do

  let(:valid_user) { create(:user) }

  let(:valid_attributes) {
    {
      name: "Monster1",
      user: valid_user,
      team: valid_user.teams.last,
      monster_type: "fire",
      power: "fire"
    }
  }

  let(:invalid_attributes) {
    {
      name: "Monster1",
      team: valid_user.teams.last,
      monster_type: "fire",
      power: "fire"
      # No user
    }
  }

  let(:valid_session) { {} }


  before(:each) do
    request.format = :json
    login_user(valid_user, request)
  end

  # describe "GET #index" do
  #   it "assigns all monsters as @monsters" do
  #     monster = create(:monster, user: valid_user, team: valid_user.teams.last)
  #     monster = monster.references(:teams)
  #     get :index

  #     expect(assigns(:monsters)).to eq([monster])
  #   end
  # end


  describe "GET #show" do
    context "with known monster id" do
      it "assigns the requested monster as @monster" do
        monster = create(:monster, user: valid_user)
        get :show, {:id => monster.to_param}
        expect(assigns(:monster)).to eq(monster)
      end
    end

    context "with unknown monster id" do
      it "renders not_found template" do
        get :show, {:id => 1234}
        expect(response.status).to eq(404)
      end
    end
  end


  describe "POST #create" do
    context "with valid params" do
      # render views to check if the response was the created monster
      render_views

      it "creates a new Monster" do
        expect {
          post :create, {:monster => valid_attributes }
        }.to change(Monster, :count).by(1)
      end

      it "assigns the newly created monster as @monster" do
        post :create, {:monster => valid_attributes}
        expect(assigns(:monster)).to be_a(Monster)
        expect(assigns(:monster)).to be_persisted
      end

      it "show newly created monster" do
        post :create, {:monster => valid_attributes}
        expect(response).to render_template(:show)
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["id"]).to eq(Monster.last.id)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested monster" do
        monster = Monster.create! valid_attributes
        put :update, {:id => monster.to_param, :monster => new_attributes}, valid_session
        monster.reload
      end

      it "assigns the requested monster as @monster" do
        monster = Monster.create! valid_attributes
        put :update, {:id => monster.to_param, :monster => valid_attributes}, valid_session
        expect(assigns(:monster)).to eq(monster)
      end
    end

    context "with invalid params" do
      it "assigns the monster as @monster" do
        monster = Monster.create! valid_attributes
        put :update, {:id => monster.to_param, :monster => invalid_attributes}, valid_session
        expect(assigns(:monster)).to eq(monster)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested monster" do
      monster = Monster.create! valid_attributes
      expect {
        delete :destroy, {:id => monster.to_param}, valid_session
      }.to change(Monster, :count).by(-1)
    end

    it "redirects to the monsters list" do
      monster = Monster.create! valid_attributes
      delete :destroy, {:id => monster.to_param}, valid_session
    end
  end

end
