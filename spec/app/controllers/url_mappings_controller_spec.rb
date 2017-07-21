require 'spec_helper'

RSpec.describe "/url_mappings" do
  describe "shorten" do
    it 'creates a new url mapping' do
      post "/shorten", { "url": "http://example.com", "shortcode": "example" }
      expect(last_response.status).to eq 200
    end
  end
  pending "add some examples to #{__FILE__}" do
    before do
      get "/url_mappings"
    end

    it "returns hello world" do
      expect(last_response.body).to eq "Hello World"
    end
  end
end
