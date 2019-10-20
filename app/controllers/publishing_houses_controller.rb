class PublishingHousesController < ApplicationController
  before_action :set_publishing_house, only: %i[show update destroy]

  def index
    @publishing_houses = PublishingHouse.all

    render json: @publishing_houses
  end

  def show
    render json: @publishing_house
  end

  def create
    @publishing_house = PublishingHouse.new(publishing_house_params)

    if @publishing_house.save
      render json: @publishing_house, status: :created, location: @publishing_house
    else
      render json: @publishing_house.errors, status: :unprocessable_entity
    end
  end

  def update
    if @publishing_house.update(publishing_house_params)
      render json: @publishing_house
    else
      render json: @publishing_house.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @publishing_house.destroy
  end

  private

  def set_publishing_house
    @publishing_house = PublishingHouse.find(params[:id])
  end

  def publishing_house_params
    params.require(:publishing_house).permit(:name, :discount)
  end
end
