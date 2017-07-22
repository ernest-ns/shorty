require 'spec_helper'

RSpec.describe "/url_mappings" do
  describe "shorten" do
    it "creates a new url mapping" do
      post "/shorten", { "url": "http://example.com", "shortcode": "example" }
      expect(last_response.status).to eq 200
    end
    context "when both url and shortcode is passed"
    context "when the url is not passed"
    context "shortcode is already in use"
    context "the shortcode is not valid"
    context "when the shorcode is not passed"
  end

  describe "shortcode" do
    let(:shortcode) {"8dsedf"}
    let(:url_mapping) {UrlMapping.create({shortcode: shortcode, url:"http://www.example.org"})}
    subject { get "/#{shortcode}" }
    it "sets the content type as json" do
      subject
      expect(last_response.content_type).to eq("application/json")
    end

    context "when shortcode is found" do
      it "redirects the user to the actual url" do
        subject
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to include(url_mapping.url)
      end

      it "looks up the shortcode" do
        expect(UrlMapping).to receive(:lookup)
        subject
      end
    end

    context "when shortcode is not found" do
      it "returns a not found response" do
        get "/noexist"
        expect(last_response.status).to eq(404)
        error_description = JSON.parse(last_response.body)["description"]
        expect(error_description).to eq("The shortcode cannot be found in the system")
      end
    end
  end


  describe "#stats" do
    let(:start_date) {5.days.ago}
    let(:last_seen_date) { 2.days.ago}
    let(:url_mapping) {UrlMapping.create({url:"http://www.example.org", redirect_count: 3, start_date: start_date, last_seen_date: last_seen_date})}
    let(:shortcode) {url_mapping.shortcode}
    subject { get "/#{shortcode}/stats" }

    it "sets the content type as json" do
      subject
      expect(last_response.content_type).to eq("application/json")
    end

    context "when the shortcode is found" do
      context "when the redirect count is zero" do
        it "responds without last_seen_date" do
          url_mapping.update!(redirect_count: 0)
          subject
          expect(last_response.status).to eq(200)
          parsed_response = JSON.parse(last_response.body)
          expect(parsed_response["lastSeenDate"]).to be nil
        end
      end

      context "when the redirect count is greater than 0" do
        it "responds with a last_seen_date" do
          subject
          expect(last_response.status).to eq(200)

          parsed_response = JSON.parse(last_response.body)
          expect(parsed_response["lastSeenDate"]).to_not be nil
          expect(parsed_response["lastSeenDate"]).to eq(url_mapping.last_seen_date.iso8601)
        end
      end

      it "returns the start date" do
        subject
        expect(last_response.status).to eq(200)

        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response["startDate"]).to_not be nil
        expect(parsed_response["startDate"]).to eq(url_mapping.start_date.iso8601)
      end

      it "returns the redirect_count" do
        subject
        expect(last_response.status).to eq(200)

        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response["redirectCount"]).to_not be nil
        expect(parsed_response["redirectCount"]).to eq(url_mapping.redirect_count)
      end
    end

    context "when the shortcode is not found" do
      it "responds with an error  message" do
        get "/noexist/stats"
        expect(last_response.status).to eq(404)
        error_description = JSON.parse(last_response.body)["description"]
        expect(error_description).to eq("The shortcode cannot be found in the system")
      end
    end
  end
end
