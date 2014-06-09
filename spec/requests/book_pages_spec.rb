require 'spec_helper'

describe "Book pages" do
  
  subject { page }

  describe "addbook page" do
    before { visit addbook_path }
  
    it { should have_selector('h1', text: 'Add new book') }
    it { should have_selector('title', text: 'Add new book') }
  end

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

        it { should have_link('delete') }
        it "should be able to delete book" do
          expect { click_link('delete') }.to change(Book, :count).by(-1)
        end
      end
    end
  end
end
