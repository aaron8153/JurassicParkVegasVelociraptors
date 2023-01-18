module V1
  class SpeciesController < ApplicationController
    before_action :set_species, only: [:show, :update, :destroy]
    before_action :set_page_info, only: [:index]

    def index
      species = Species.page(@page).per(@per_page)
      render_json(SpeciesSerializer, species, {meta: {message: ['Species list fetched successfully']}})
    end

    def show
      if @species.nil?
        data = { errors: [] }
        data[:errors] << {id: params[:id], message: 'Species not found', status: 422, type: :unprocessable_entity }
        render json: data, status: :unprocessable_entity
      else
        render_json(SpeciesSerializer, @species, {meta: {message: ['Species fetched successfully']}})
      end
    end

    def create
      @species = Species.new(species_params)
      if @species.save
        render json: @species, status: :created
      else
        render json: @species.errors, status: :unprocessable_entity
      end
    end

    def update
      if @species.update(species_params)
        render_json(SpeciesSerializer, @species)
      else
        render json: @species.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @species.destroy
    end

    private

    def set_species
      begin
        @species = Species.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @species = nil
      end
    end

    def species_params
      params.require(:species).permit(:name, :carnivorous)
    end
  end
end