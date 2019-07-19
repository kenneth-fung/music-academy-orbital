class StaticPagesController < ApplicationController
  def home
    @courses_beginners = Course
    .left_outer_joins(:tags)
    .where('LOWER(tags.name) LIKE ? AND rating > ?', '%beginner%', '3')
    .reorder(Arel.sql('RANDOM()'))
    .distinct
    .limit(4)

    @courses_hot = Course
    .left_outer_joins(:subscriptions)
    .where('subscriptions.created_at > ? AND rating > ?', 1.week.ago, '2')
    .reorder(Arel.sql('RANDOM()'))
    .distinct
    .limit(4)

    @tutors = Tutor
    .reorder(popularity: :desc)
    .offset(rand(1..8))
    .limit(4)

    @instrument = Faker::Music.instrument
    @courses_instrument = instrument_collection(@instrument)

    @instrument_two = Faker::Music.instrument
    while @instrument_two == @instrument
      @instrument_two = Faker::Music.instrument
    end
    @courses_instrument_two = instrument_collection(@instrument_two)
  end

  def signup
    @student = Student.new
    @tutor = Tutor.new
  end

  def contact
  end

  def about
  end

  private

  # Returns a collection of courses involving the given instrument
  def instrument_collection(instrument)
    Course
    .where('LOWER(title) LIKE ? AND rating > ?', "%#{instrument.downcase}%", '2')
    .reorder(Arel.sql('RANDOM()'))
    .distinct
    .limit(4)
  end
end
