module Comable
  class Page < ActiveRecord::Base
    include Comable::Ransackable

    validates :title, length: { maximum: 255 }, presence: true
    validates :content, presence: true
    validates :page_title, length: { maximum: 255 }
    validates :meta_description, length: { maximum: 255 }
    validates :meta_keywords, length: { maximum: 255 }
    validates :slug, length: { maximum: 255 }, presence: true, uniqueness: true
  end
end
