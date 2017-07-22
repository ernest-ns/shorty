module ShortcodeValidator
  def self.valid? shortcode
    /^[0-9a-zA-Z_]{4,}$/ === shortcode
  end
end
