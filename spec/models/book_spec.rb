require 'spec_helper'

describe Book do

  before do
    @book = Book.new(title: "Book1", author: "Author1",
                     year: "2014", synopsis: "This is book1", copies: 1)
  end

  subject { @book }

  it { should respond_to(:title) }
  it { should respond_to(:author) }
  it { should respond_to(:year) }
  it { should respond_to(:synopsis) }
  it { should respond_to(:copies) }

  it { should be_valid }

  describe "when title is not present" do
    before { @book.title = " " }
    it { should_not be_valid }
  end

  describe "when author is not present" do
    before { @book.author = " " }
    it { should_not be_valid }
  end

  describe "when synopsis is too long" do
    before { @book.synopsis = "a" * 151 }
    it { should_not be_valid }
  end

  describe "when book is not unique" do
    before do
      same_book = @book.dup
      same_book.save
    end

    it { should_not be_valid }
  end
end

