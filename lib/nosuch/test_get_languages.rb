require "#{File.dirname(__FILE__)}/db"


RSpec.describe Client::Nosuch::Database do

  get_nosuch_languages
  collection = languages.build

  describe "#build" do
    it "should return a collection" do
      collection.instance_of? Array and collection.length > 0
    end
  end

  ["name", "computer/Os", "year", "author", "manipulates", "web", "implementation", "paper", "description"].each{|e|
    d = "##{e}_value"
    describe d do
      it "should return a #{e} value" do
        b = false
        collection.each{|obj| obj[e] ? b = true : b = false}
        b
      end
    end
  }

  describe "#json" do
    it "should return a valid json" do
      json = languages.parse_json
      puts json
      json.instance_of? String
    end
  end

end
