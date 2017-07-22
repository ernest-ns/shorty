require 'spec_helper'

RSpec.describe ShortcodeValidator do
  context "for a valid shortcode" do
    it "returns true" do
      valid_shortcode = "8wer_"
      expect(ShortcodeValidator.valid?(valid_shortcode)).to be true
    end
  end

  context "for a invalid shortcode" do
    it "returns false" do
      invalid_shortcode = "8we"
      expect(ShortcodeValidator.valid?(invalid_shortcode)).to be false

      invalid_shortcode = "8we-"
      expect(ShortcodeValidator.valid?(invalid_shortcode)).to be false
    end
  end
end
