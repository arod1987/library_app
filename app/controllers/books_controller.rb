class BooksController < ApplicationController
  before_filter :signed_in_user, only: [:index, :hire, :return]
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

  def hire
    @book = Book.find(params[:id])
    if @book.copies == @book.users.count
      flash[:error] = "Sorry! " + @book.title + " not available to hire! Try again later!"
      redirect_to books_path
    else
      @book.users << current_user
      flash[:success] = @book.title + " hired!" 
      redirect_to user_path(current_user)
    end
  end

  def return
    @book = Book.find(params[:id])
    if @book.users.exists?(current_user)
      @book.users.destroy(current_user)
      flash[:success] = @book.title + " returned!"
      redirect_to user_path(current_user)
    else
      flash[:error] = "You can return books hired by you only. " + @book.title + " is not on your list!"
      redirect_to user_path(current_user)
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
