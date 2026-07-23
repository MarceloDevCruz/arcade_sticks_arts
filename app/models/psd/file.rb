class Psd::File < ApplicationRecord
  self.table_name = "psd_files"

  has_one_attached :psd

  validates :title, presence: true
  validates :psd, presence: true
end