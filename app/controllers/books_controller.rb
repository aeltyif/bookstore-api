class BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]

  def index
    @books = Book.limit(params[:limit]).includes(:author, :publisher)
    render json: @books, meta: { total: Book.count }
  end

  def show
    render json: @book
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    parsed = ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:publisher])
    parsed[:publisher_type] = parsed[:publisher_type].singularize.capitalize
    parsed.except(:discount)
  end
end
