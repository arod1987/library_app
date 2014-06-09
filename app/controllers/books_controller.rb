class BooksController < ApplicationController
  before_filter :signed_in_user, only: [:index]
  before_filter :admin_user, only: [:edit, :update, :destroy]
  
  def show
    @book = Book.find(params[:id])
  end

  def new
  end

  def index
    @books = Book.paginate(page: params[:page])
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
