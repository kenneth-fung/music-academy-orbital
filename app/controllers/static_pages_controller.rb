class StaticPagesController < ApplicationController
  before_action :generate_greeting, only: :home

  def home
    # Courses for Beginners / Courses to Get You Started
    @courses_beginners = Course
    .left_outer_joins(:tags)
    .where('LOWER(tags.name) LIKE ? AND rating > ?', '%beginner%', '3')
    .reorder(Arel.sql('RANDOM()'))
    .limit(4)

    # Your Most Recent Enrollments
    @courses_student = current_user
    .courses
    .where.not(id: current_user.pending_course)
    .sort_student_courses(current_user, 'newest')
    .limit(4) if student?

    # Recommended Courses for You
    courses_recommend = Course
    .recommended(current_user
                 .courses
                 .where.not(id: current_user.pending_course)) if student?
    @courses_recommend = courses_recommend
    .offset(rand(0...(courses_recommend.count - 4)))
    .limit(4) if student?

    # What Students are Looking at Right Now
    courses_hot = Course
    .left_outer_joins(:subscriptions)
    .where('subscriptions.created_at > ? AND rating > ?', 3.days.ago, '2')
    .distinct
    @courses_hot = courses_hot
    .offset(rand(0...(courses_hot.count - 4)))
    .limit(4)

    # Some of Our Tutors
    @tutors = Tutor
    .reorder(popularity: :desc)
    .offset(rand(1..8))
    .limit(4)

    # Instrument Courses 1
    @instrument = Faker::Music.instrument
    @courses_instrument = instrument_collection(@instrument)

    # Instrument Courses 2
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

  # Generates a greeting in a random language
  def generate_greeting
    languages = %w[French  Spanish English   Italian Hindi Japanese   Korean   Chinese Tamil   Polish Dutch German     Swedish]
    greetings = %w[Bonjour Hola    Greetings Ciao    שלום  こんにちは 여보세요 你好    வணக்கம்   Cześć  Hallo Guten\ Tag Hej]
    selection = rand(languages.length)
    @greeting_language = languages[selection]
    @greeting = greetings[selection]
  end

  # Returns a collection of courses involving the given instrument
  def instrument_collection(instrument)
    Course
    .where('LOWER(title) LIKE ? AND rating > ?', "%#{instrument.downcase}%", '2')
    .reorder(Arel.sql('RANDOM()'))
    .limit(4)
  end
end
