module Comable
  class Page < ActiveRecord::Base
    include Comable::Ransackable

    extend FriendlyId
    friendly_id :slug, use: :slugged

    validates :title, length: { maximum: 255 }, presence: true
    validates :content, presence: true
    validates :page_title, length: { maximum: 255 }
    validates :meta_description, length: { maximum: 255 }
    validates :meta_keywords, length: { maximum: 255 }
    validates :slug, length: { maximum: 255 }, presence: true, uniqueness: true

    PREVIEW_SESSION_KEY = :preview_page

    def published?
      published_at.present? && published_at <= Time.now
    end
  end
end
