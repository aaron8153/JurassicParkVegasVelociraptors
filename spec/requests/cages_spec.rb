require 'rails_helper'

RSpec.describe "Cages", type: :request do
  describe "GET #index" do
    it "returns a success response" do
      get '/v1/cages'
      expect(response).to be_successful
    end

    it "returns all the cages" do
      create_list(:cage, 3)
      get '/v1/cages'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(3)
    end

    it "correctly paginates" do
      create_list(:cage, 15)
      get '/v1/cages/'
      body = JSON.parse(response.body)
      expect(body['data'].size).to eq(10)
      expect(body['meta']['pagination']['current_page']).to eq(1)
      expect(body['meta']['pagination']['prev_page']).to be_nil
      expect(body['meta']['pagination']['next_page']).to eq(2)
      expect(body['meta']['pagination']['total_pages']).to eq(2)
    end

    describe "relationships" do
      let!(:species1) {
        create(:species)
      }
      let!(:species2) {
        create(:species)
      }
      let!(:cage1) {
        create(:cage, :powered, species: species1)
      }
      let!(:cage2) {
        create(:cage, :powered, species: species2)
      }
      let!(:dinosaur1){
        create(:dinosaur, species: species1, cage: cage1)
      }
      let!(:dinosaur2){
        create(:dinosaur, species: species1, cage: cage1)
      }
      let!(:dinosaur3){
        create(:dinosaur, species: species2, cage: cage2)
      }
      let!(:dinosaur4){
        create(:dinosaur, species: species2, cage: cage2)
      }

      context "species" do
        it "returns the correct species" do
          get '/v1/cages/'
          body = JSON.parse(response.body)
          expect(body['data'].size).to eq(2)
          cage1_body = body['data'][0]['relationships']
          species_body = cage1_body['species']['data']
          expect(species_body['id']).to eq(species1.id.to_s)
          expect(species_body['type']).to eq('species')

          cage2_body = body['data'][1]['relationships']
          species_body = cage2_body['species']['data']
          expect(species_body['id']).to eq(species2.id.to_s)
          expect(species_body['type']).to eq('species')
        end
      end

      context "dinosaurs" do
        it "returns the correct dinosaurs" do
          get '/v1/cages/'
          body = JSON.parse(response.body)
          expect(body['data'].size).to eq(2)
          cage1_body = body['data'][0]['relationships']
          dinosaurs_body = cage1_body['dinosaurs']['data'][0]
          expect(dinosaurs_body['id']).to eq(dinosaur1.id.to_s)
          expect(dinosaurs_body['type']).to eq('dinosaur')
          dinosaurs_body2 = cage1_body['dinosaurs']['data'][1]
          expect(dinosaurs_body2['id']).to eq(dinosaur2.id.to_s)
          expect(dinosaurs_body2['type']).to eq('dinosaur')

          cage2_body = body['data'][1]['relationships']
          dinosaurs_body = cage2_body['dinosaurs']['data'][0]
          expect(dinosaurs_body['id']).to eq(dinosaur3.id.to_s)
          expect(dinosaurs_body['type']).to eq('dinosaur')
          dinosaurs_body2 = cage2_body['dinosaurs']['data'][1]
          expect(dinosaurs_body2['id']).to eq(dinosaur4.id.to_s)
          expect(dinosaurs_body2['type']).to eq('dinosaur')

        end
      end
    end
  end

  describe "GET #show" do
    describe "record exists" do
      let!(:cage) { create(:cage, :powered)}
      it "returns a success response when record found" do
        get "/v1/cages/#{cage.id}"
        expect(response).to be_successful
      end
    end

    describe "record does not exist" do
      it "returns unprocessable_entity response when record not found" do
        get "/v1/cages/123"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Cage" do
        expect {
          post "/v1/cages", params: { cage: { name: "Big House", max_capacity: 10 } }
        }.to change(Cage, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new Cage" do
        expect {
          post "/v1/cages", params: { cage: { name: "" } }
        }.not_to change(Cage, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    let!(:cage) {
      create(:cage)
    }
    context "with valid params" do
      it "updates the correct Cage" do
        put "/v1/cages/#{cage.id}", params: { cage: { name: "New Name", max_capacity: 5, power_status: Cage::ACTIVE } }
        cage.reload
        expect(cage.name).to eq('New Name')
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['data']['attributes']['name']).to eq('New Name')
      end
    end

    context "with invalid params" do
      it "does not create a new Species" do
        put "/v1/cages/#{cage.id}", params: { cage: { name: "" } }
        cage.reload
        expect(cage.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['name'][0]).to eq('can\'t be blank')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:cage) {
      create(:cage)
    }
    it "destroys the correct Cage" do
      expect {
        delete "/v1/cages/#{cage.id}"
      }.to change(Cage, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
