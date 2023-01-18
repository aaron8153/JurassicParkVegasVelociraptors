require 'rails_helper'

RSpec.describe "Dinosaurs", type: :request do
  let!(:species_carnivore) {
    create(:species, :carnivore_diet)
  }
  describe "GET #index" do
    it "returns a success response" do
      get '/v1/dinosaurs'
      expect(response).to be_successful
    end

    it "returns all the dinosaurs" do
      create_list(:dinosaur, 3, species: species_carnivore)
      get '/v1/dinosaurs'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(3)
    end

    it "correctly paginates" do
      create_list(:dinosaur, 15, species: species_carnivore)
      get '/v1/dinosaurs/'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(10)
      expect(body['meta']['pagination']['current_page']).to eq(1)
      expect(body['meta']['pagination']['prev_page']).to be_nil
      expect(body['meta']['pagination']['next_page']).to eq(2)
      expect(body['meta']['pagination']['total_pages']).to eq(2)
    end

    describe "relationships" do

      context "species" do
        it "returns the correct species" do
          # Do the same sort of spec as for Cage
        end
      end

      context "cages" do
        it "returns the correct cages" do
          # Do the same sort of spec as for Cage
        end
      end
    end
  end

  describe "GET #show" do
    describe "record exists" do
      let!(:dinosaur) { create(:dinosaur, species: species_carnivore)}
      it "returns a success response when record found" do
        get "/v1/dinosaurs/#{dinosaur.id}"
        expect(response).to be_successful
      end
    end

    describe "record does not exist" do
      it "returns unprocessable_entity response when record not found" do
        get "/v1/dinosaurs/123"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let!(:dinosaur) { create(:dinosaur, species: species_carnivore)}
      it "creates a new dinosaur" do
        expect {
          post "/v1/dinosaurs", params: { dinosaur: { name: "Little Tim", species_id: species_carnivore.id } }
        }.to change(Dinosaur, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new dinosaur" do
        expect {
          post "/v1/dinosaurs", params: { dinosaur: { name: "" } }
        }.not_to change(Dinosaur, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    let!(:dinosaur) {
      create(:dinosaur, species: species_carnivore)
    }
    context "with valid params" do
      it "updates the correct dinosaur" do
        put "/v1/dinosaurs/#{dinosaur.id}", params: { dinosaur: { name: "Big Tom" } }
        dinosaur.reload
        expect(dinosaur.name).to eq('Big Tom')
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['data']['attributes']['name']).to eq('Big Tom')
      end
    end

    context "with invalid params" do
      it "does not create a new Species" do
        put "/v1/dinosaurs/#{dinosaur.id}", params: { dinosaur: { name: "" } }
        dinosaur.reload
        expect(dinosaur.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['name'][0]).to eq('can\'t be blank')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:dinosaur) {
      create(:dinosaur, species: species_carnivore)
    }
    it "destroys the correct dinosaur" do
      expect {
        delete "/v1/dinosaurs/#{dinosaur.id}"
      }.to change(Dinosaur, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
