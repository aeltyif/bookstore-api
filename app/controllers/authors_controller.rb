class AuthorsController < ApplicationController
  include RequestValidator

  before_action :set_author, only: %i[show update destroy]

  def index
    @authors = Author.all

    render json: @authors
  end

  def show
    render json: @author, include: ['books']
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      render json: @author, status: :created, location: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def issue_to_author
    request.body.rewind
    if RequestValidator.valid_signature?(request)
      GithubIssueWorker.perform_async(params[:payload])
      render status: :accepted, json: { body: 'Request received' }.to_json
    else
      render status: :bad_request, json: { body: 'Invalid request was provided' }.to_json
    end
  end

  def update
    if @author.update(author_params)
      render json: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
