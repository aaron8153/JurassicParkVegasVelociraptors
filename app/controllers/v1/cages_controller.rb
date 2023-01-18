module V1
  class CagesController < ApplicationController
    before_action :set_cage, only: [:show, :update, :destroy]
    before_action :set_page_info, only: [:index]

    def index
      cages = Cage.all.includes(:species, :dinosaurs).page(@page).per(@per_page)
      render_json(CageSerializer, cages, {meta: {message: ['Cages list fetched successfully']}})
    end

    def show
      if @cage.nil?
        data = { errors: [] }
        data[:errors] << {id: params[:id], message: 'Cage not found', status: 422, type: :unprocessable_entity }
        render json: data, status: :unprocessable_entity
      else
        render_json(CageSerializer, @cage, {meta: {message: ['Cage fetched successfully']}})
      end
    end

    def create
      @cage = Cage.new(cage_params)
      if @cage.save
        render json: @cage, status: :created
      else
        render json: @cage.errors, status: :unprocessable_entity
      end
    end

    def update
      if @cage.update(cage_params)
        render_json(CageSerializer, @cage)
      else
        render json: @cage.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @cage.destroy
    end

    private

    def set_cage
      begin
        @cage = Cage.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @cage = nil
      end
    end

    def cage_params
      params.require(:cage).permit(:name, :max_capacity, :power_status, :species)
    end
  end
end