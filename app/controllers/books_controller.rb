class BooksController < ApplicationController
  before_filter :signed_in_user, only: [:index]
  before_filter :admin_user, only: [:new, :edit, :update, :destroy]
  
  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def index
    @books = Book.paginate(page: params[:page])
  end

  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:success] = "New book added!"
      redirect_to @book
    else
      render 'new'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      flash[:success] = "Book updated"
      redirect_to @book      
    else
      render 'edit'
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "Book destroyed."
    redirect_to books_url
  end

  private
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
