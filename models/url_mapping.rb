# -*- coding: utf-8 -*-
class UrlMapping < ActiveRecord::Base
  before_create :generate_start_date
  before_create :assign_shortcode

  validates :shortcode, uniqueness: {message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."}
  validate :shortcode_follows_format
  validates :url, presence: {message: "url is not present"}
  validates :url, format: { with: URI.regexp }, if: 'url.present?'

  def generate_start_date
    self.start_date = Time.now if self.start_date.blank?
  end

  def assign_shortcode
    self.shortcode = UrlMapping.generate_shortcode if self.shortcode.blank?
  end

  def self.generate_shortcode(length=6)
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9') + ['_']
    Array.new(length) { charset.sample }.join
  end

  def self.lookup(shortcode)
    url_mapping = UrlMapping.where({shortcode: shortcode}).take
    return url_mapping unless url_mapping
    url_mapping.update_redirect_count
    url_mapping.update_last_seen_date
    url_mapping
  end

  def update_redirect_count
    self.increment(:redirect_count)
  end

  def update_last_seen_date
    self.update_attribute(:last_seen_date, Time.now)
  end

  def shortcode_follows_format
    return if shortcode.blank?
    unless ShortcodeValidator.valid?(shortcode)
      errors.add(:shortcode, "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$")
    end
  end
end
