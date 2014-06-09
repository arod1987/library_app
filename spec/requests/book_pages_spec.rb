require 'spec_helper'

describe "Book pages" do
  
  subject { page }

  describe "book page" do
    let(:book) { FactoryGirl.create(:book) }
    before { visit book_path(book) }

    it { should have_selector('h1', text: book.title) }
    it { should have_selector('title', text: book.title) }

  end

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit books_path
    end

    it { should have_selector('title', text: 'All books') }
    it { should have_selector('h1', text: 'All books') }

    describe "pagination" do
      
      before(:all) { 50.times { FactoryGirl.create(:book) } }
      after(:all) { Book.delete_all }

      it { should have_selector('div.pagination') }
    
      it "should list each book" do
        Book.paginate(page: 1).each do |book|
          page.should have_selector('li', text: book.title)
        end
      end
    end

    describe "delete links" do
    
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin          
          visit books_path
        end

        it { should have_link('delete', href: books_path) }
        it "should be able to delete book" do
          expect { click_link('delete') }.to change(Book, :count).by(-1)
        end
      end
    end
  end

  describe "addbook" do
  
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      sign_in admin
      visit addbook_path
    end

    let(:submit) { "Add book" }

    describe "with admin user" do
      it {should have_selector('h1', text: 'Add new book') }
      it {should have_selector('title', text: 'Add new book') }
    end

    describe "with invalid information" do
      it "should not create a book" do
        expect { click_button submit }.not_to change(Book, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title", with: "LibraryBook"
        fill_in "Author", with: "Author"
        fill_in "Year", with: "2014"
        fill_in "Synopsis", with: "This is a book"
        fill_in "Copies", with: 5
      end

      it "should create a book" do
        expect { click_button submit }.to change(Book, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:book) { FactoryGirl.create(:book) }
    before do 
      sign_in admin
      visit edit_book_path(book)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update book") }
      it { should have_selector('title', text: "Edit book") }
    end

    describe "with invalid information" do
      before do
        fill_in "Title", with: ""
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_title) { "New Library Book" }
      let(:new_author) { "New Author" }
      before do
        fill_in "Title", with: new_title
        fill_in "Author", with: new_author
        fill_in "Synopsis", with: book.synopsis
        fill_in "Year", with: book.year
        fill_in "Copies", with: book.copies
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_title) }
      it { should have_selector('div.alert.alert-success') }
      specify { book.reload.title.should == new_title }
      specify { book.reload.author.should == new_author }
    end
  end
end
