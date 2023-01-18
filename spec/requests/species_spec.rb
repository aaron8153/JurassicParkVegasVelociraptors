require 'rails_helper'

RSpec.describe "Species", type: :request do

  describe "GET #index" do
    it "returns a success response" do
      get '/v1/species'
      expect(response).to be_successful
    end

    it "returns all the species" do
      create_list(:species, 3)
      get '/v1/species/'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(3)
    end

    it "correctly paginates" do
      create_list(:species, 15)
      get '/v1/species/'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(10)
      expect(body['meta']['pagination']['current_page']).to eq(1)
      expect(body['meta']['pagination']['prev_page']).to be_nil
      expect(body['meta']['pagination']['next_page']).to eq(2)
      expect(body['meta']['pagination']['total_pages']).to eq(2)
    end

  end

  describe "GET #show" do
    describe "record exists" do
      let!(:species_herbivore) { create(:species, :herbivore_diet)}
      it "returns a success response when record found" do
        get "/v1/species/#{species_herbivore.id}"
        expect(response).to be_successful
      end
    end

    describe "record does not exist" do
      it "returns unprocessable_entity response when record not found" do
        get "/v1/species/123"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Species" do
        expect {
          post "/v1/species", params: { species: { name: "T-Rex", carnivorous: true } }
        }.to change(Species, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new Species" do
        expect {
          post "/v1/species", params: { species: { name: "", carnivorous: true } }
        }.not_to change(Species, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  describe "PUT #update" do
    let!(:species) {
      create(:species)
    }
    context "with valid params" do
      it "updates the correct Species" do
        put "/v1/species/#{species.id}", params: { species: { name: "New Name" } }
        species.reload
        expect(species.name).to eq('New Name')
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['data']['attributes']['name']).to eq('New Name')
      end
    end

    context "with invalid params" do
      it "does not create a new Species" do
        put "/v1/species/#{species.id}", params: { species: { name: "" } }
        species.reload
        expect(species.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['name'][0]).to eq('can\'t be blank')
      end
    end

  end

  describe "DELETE #destroy" do
    let!(:species) {
      create(:species)
    }
    it "destroys the correct species" do
      expect {
        delete "/v1/species/#{species.id}"
      }.to change(Species, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

  end
end
