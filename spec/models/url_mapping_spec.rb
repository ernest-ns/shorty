require 'spec_helper'

RSpec.describe UrlMapping do
  describe "Generating Shortcodes with #generate_shortcode" do
    it "generates a shortcode of length 6" do
      generated_shortcode = UrlMapping.generate_shortcode
      expect(generated_shortcode.length).to eq(6)
    end

    it "inclued only valid chars" do
      generated_shortcode = UrlMapping.generate_shortcode
      expect(/^[0-9a-zA-Z_]{6}$/ === generated_shortcode).to be true
    end
  end

  describe "Shortcode" do
    context "when shortcode is not passed" do
      it "generates shortcode before creation" do
        url_mapping = UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/"})
        expect(url_mapping.shortcode).to_not be nil
      end

      it "uses the generator to assign shortcode" do
        expect(UrlMapping).to receive(:generate_shortcode).and_return("newcod")
        url_mapping = UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/"})
      end
    end

    context "when the shortcode is passed" do
      it "does not generate a shortcode" do
        expect(UrlMapping).to_not receive(:generate_shortcode)
        url_mapping = UrlMapping.create({shortcode: "oldCod", url: "https://www.example.com/foo/?bar=baz&inga=42&quux/"})
      end
    end
  end

  describe "Validation" do
    let(:url_mapping) {UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/", shortcode: "string"})}

    it 'validates that the shortcode is uniq' do
      duplicate_url_mapping = UrlMapping.new({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/", shortcode: "string"})
      duplicate_url_mapping.valid?
      expect(duplicate_url_mapping.errors[:shortcode].include?("The the desired shortcode is already in use. Shortcodes are case-sensitive.")).to be true
    end

    it "validates that the url is present" do
      url_mapping = UrlMapping.new({})
      url_mapping.valid?
      expect(url_mapping.errors[:url].include?("url is not present")).to be true
    end

    it "validates that the url is of type URL" do
      url_mapping.valid?
      expect(url_mapping.errors[:url].include?("is invalid")).to be false


      url_mapping = UrlMapping.new({url: "meh"})
      url_mapping.valid?
      expect(url_mapping.errors[:url].include?("url is not valid")).to be true

    end
    it "Validates that the shortcord follows the pattern" do
      url_mapping = UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/", shortcode: "-12asdfg"})
      expect(url_mapping.errors[:shortcode].include?("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$")).to be true
    end
  end

  describe "#lookup" do
    let(:url_mapping) {UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/"})}
    context "when a url mapping is found" do
      subject {UrlMapping.lookup(url_mapping.shortcode)}

      it "returns the found UrlMapping" do
        expect(subject.id).to eq(url_mapping.id)
      end
    end
    context "after lookup" do
      subject {UrlMapping.lookup(url_mapping.shortcode)}

      before(:each) do
        expect(UrlMapping).to receive_message_chain(:where, :take).and_return(url_mapping)
      end

      it "increases the redirect count" do
        expect(url_mapping).to receive(:update_redirect_count)
        subject
      end
      it "updates the last_seen_date" do
        expect_any_instance_of(UrlMapping).to receive(:update_last_seen_date)
        subject
      end
    end
    context "when a url mapping is not found" do
      it "return nil" do
        expect(UrlMapping.lookup("shortcode")).to eq(nil)
      end
    end
  end


  describe "update_redirect_count" do
    let(:url_mapping) {UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/"})}
    subject {url_mapping.update_redirect_count}

    it "increases the redirect_count" do
      expect{subject}.to change{ url_mapping.redirect_count}.by(1)
    end
  end

  describe "#update_last_seen_date" do
    let(:url_mapping) {UrlMapping.create({url: "https://www.example.com/foo/?bar=baz&inga=42&quux/", last_seen_date: 5.days.ago})}
    subject {url_mapping.update_last_seen_date}

    it "updates the last_seen_date with the current datetime stamp" do
      subject
      expect(url_mapping.last_seen_date.strftime("%d%m%Y%H")).to eq(Time.now.utc.strftime("%d%m%Y%H"))
    end
  end
end
