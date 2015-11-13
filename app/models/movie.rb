class Movie < ActiveRecord::Base
  def self.all_ratings
    return Movie.pluck(:rating).uniq
  end
end
