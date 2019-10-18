class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :update, :destroy]

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
    issue_data = github_issue_params
    if issue_data.permitted?
      GithubIssueWorker.perform_async(issue_data.as_json)
      render status: 202, json: { body: 'Request Received' }.to_json
    else
      render status: 400, json: { body: 'This is not an issue' }.to_json
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

  def github_issue_params
    params.require(:issue).permit(:title, :body)
  end
end
