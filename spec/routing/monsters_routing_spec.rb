require "rails_helper"

RSpec.describe MonstersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "api/monsters").to route_to("monsters#index")
    end

    it "routes to #create" do
      expect(post: "api/monsters").to route_to("monsters#create")
    end

    it "routes to #show" do
      expect(get: "api/monsters/1").to route_to("monsters#show", id: "1")
    end

    it "routes to #update" do
      expect(put: "api/monsters/1").to route_to("monsters#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "api/monsters/1").to route_to("monsters#destroy", id: "1")
    end

  end
end
