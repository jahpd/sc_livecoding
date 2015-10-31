require "#{File.dirname(__FILE__)}/db"

RSpec.describe Client::Nosuch::Database  do

  it "should get data" do  
    doc = Client::Nosuch::Database.get_nosuch_languages()
    expect(doc.instance_of? Nokogiri::HTML).to eq(true)
  end


end
