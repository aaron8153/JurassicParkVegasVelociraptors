
module V1
  class DinosaursController < ApplicationController
    before_action :set_dinosaur, only: [:show, :update, :destroy]
    before_action :set_page_info, only: [:index]

    def index
      dinosaur = Dinosaur.page(@page).per(@per_page)
      render_json(DinosaurSerializer, dinosaur, {meta: {message: ['Dinosaur list fetched successfully']}})
    end

    def show
      if @dinosaur.nil?
        data = { errors: [] }
        data[:errors] << {id: params[:id], message: 'dinosaur not found', status: 422, type: :unprocessable_entity }
        render json: data, status: :unprocessable_entity
      else
        render_json(DinosaurSerializer, @dinosaur, {meta: {message: ['dinosaur fetched successfully']}})
      end
    end

    def create
      @dinosaur = Dinosaur.new(dinosaur_params)
      if @dinosaur.save
        render json: @dinosaur, status: :created
      else
        render json: @dinosaur.errors, status: :unprocessable_entity
      end
    end

    def update
      if @dinosaur.update(dinosaur_params)
        render_json(DinosaurSerializer, @dinosaur)
      else
        render json: @dinosaur.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @dinosaur.destroy
    end

    private

    def set_dinosaur
      begin
        @dinosaur = Dinosaur.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @dinosaur = nil
      end
    end



    def dinosaur_params
      params.require(:dinosaur).permit(:name, :species_id, :cage_id)
    end
  end
end