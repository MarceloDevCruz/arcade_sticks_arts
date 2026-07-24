class Psd::File < ApplicationRecord
  self.table_name = "psd_files"

  has_one_attached :psd
  has_one_attached :preview

  validates :title, presence: true
  validates :psd, presence: true
end