require 'spec_helper'

describe APR::Drivers::Quizlet do

  let(:driver) { APR::Drivers::Quizlet.new(config_data[:quizlet]) }

  describe ".initialize" do
    it "should throw error when intializing without proper config options" do
      expect {
        APR::Drivers::Quizlet.new
      }.to raise_error(ArgumentError)
    end
  end

  describe "#perform_request" do
    it "should raise error when perform_request method is called without a query" do
      expect {
        driver.perform_request(APR::RequestCriteria.new)
      }.to raise_error(StandardError, "must include query")
    end

    it "should perform request", :vcr, :record => :none do
      search_criteria = APR::RequestCriteria.new({:query => "dogs"})
      results = driver.perform_request(search_criteria)

      next_criteria = results.next_criteria
      next_criteria.page.should eq(2)
      next_criteria.per_page.should eq(25)
      results.items.length.should eq(25)

      quiz = results.items.first
      quiz.kind.should eq("quiz")
      quiz.title.should eq("Dogs")
      quiz.description.should eq("DOGS, DOGS, DOGS!!!!!!!!")
      quiz.url.should eq("http://quizlet.com/23752218/dogs-flash-cards/")
      quiz.created_date.strftime("%Y-%m-%d").should eq("2013-05-25")

      quiz.return_types.map(&:url).should eq([
        "http://quizlet.com/23752218/dogs-flash-cards/",
        "https://quizlet.com/23752218/flashcards/embedv2",
        "https://quizlet.com/23752218/learn/embedv2",
        "https://quizlet.com/23752218/scatter/embedv2",
        "https://quizlet.com/23752218/speller/embedv2",
        "https://quizlet.com/23752218/test/embedv2",
        "https://quizlet.com/23752218/spacerace/embedv2"
      ])
    end
  end
  
end