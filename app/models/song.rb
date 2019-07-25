class Song < ApplicationRecord
  validates :title, presence: true
  validates :release_year, numericality: {less_than_or_equal_to: Time.new.year,
                                          only_integer: true, :allow_nil => true}
  validates :artist_name, presence: true
  validate :no_repeat
  validate :year_op

  def no_repeat
    # Title cannot be repeated by the same artist in the same year
    existing_song = Song.find_by(title: title, release_year: release_year, artist_name: artist_name)
    if existing_song
      errors.add(:title, "artist already has a song by that name this year")
    end
  end

  def year_op
    # Year optional if released is false
    if released && release_year.nil?
      errors.add(:release_year, "need a release year if a song's been released")
    end
  end
end
