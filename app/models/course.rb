class Course < ApplicationRecord
  belongs_to :tutor
  has_many :lessons, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :student
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :reviews, dependent: :destroy

  after_save :parse_tag_list

  has_one_attached :image
  validate :image_file_type

  scope :newest,        -> { order(created_at: :desc) }
  scope :oldest,        -> { order(created_at: :asc) }
  scope :lowest_price,  -> { order(price: :asc) }
  scope :highest_price, -> { order(price: :desc) }
  scope :top_rated,     -> { order(rating: :desc) }
  scope :most_popular,  -> { order(popularity: :desc) }

  validates :title,
    presence: true,
    length: {maximum: 50}

  validates :language,
    presence: true,
    length: {maximum: 200}

  validates :price,
    presence: true,
    numericality: {greater_than_or_equal_to: 0}

  validates :tutor,
    presence: true

  # Queries the Course table only, and only its title column
  def Course.search_title(query)
    return self if query.nil? or query.blank?
    query_terms = query.split

    title_query = [(['(LOWER(title) LIKE ?)'] * query_terms.length).join(' AND ')]

    # Construct complete array of query terms to feed to SQL fragment
    complete_query_terms = []
    query_terms.each {|query_term| complete_query_terms << query_term.downcase}
    # Add % % to each query term so that it is searched for as a substring
    complete_query_terms.map! {|query_term| "%#{query_term}%"}

    # Execute the complete SQL query
    where(title_query + complete_query_terms)
  end

  # Queries the Course, Tutor, and Lessons tables
  def Course.search(query)
    return self if query.nil? or query.blank?
    query_terms = query.split

    # Create the SQL fragment for individual query terms
    individual_query = ['(LOWER(title) LIKE ?
                        OR LOWER(content) LIKE ? 
                        OR LOWER(tutors.name) LIKE ? 
                        OR LOWER(lessons.name) LIKE ? 
                        OR LOWER(lessons.description) LIKE ?
                        OR LOWER(tags.name) LIKE ?)']
    # Form complete SQL fragment based on number of query terms
    complete_query = [(individual_query * query_terms.length).join(' AND ')]

    # Construct complete array of query terms to feed to SQL fragment
    complete_query_terms = []
    query_terms.each {|query_term| 6.times {complete_query_terms << query_term.downcase}}
    # Add % % to each query term so that it is searched for as a substring
    complete_query_terms.map! {|query_term| "%#{query_term}%"}

    # Execute the complete SQL query
    left_outer_joins(:tutor, :lessons, :tags).where(complete_query + complete_query_terms).distinct
  end

  # Changes the scope (order of courses) based on sort param
  def Course.sort(sort_by)
    case sort_by
    when 'newest'
      newest
    when 'oldest'
      oldest
    when 'lowest_price'
      lowest_price
    when 'highest_price'
      highest_price
    when 'top_rated'
      top_rated
    when 'most_popular'
      most_popular
    else
      newest
    end
  end

  # Returns a given student's courses sorted in a given order
  def Course.sort_student_courses(student, sort_by)
    case sort_by
    when 'oldest'
      self.merge(Subscription
                 .where(student_id: student.id)
                 .reorder(created_at: :asc))
    else
      # sort by newest subscriptions first by default
      self.merge(Subscription
                 .where(student_id: student.id)
                 .reorder(created_at: :desc))
    end
  end

  # Returns a tutor's courses sorted in a given order
  def Course.sort_tutor_courses(sort_by)
    case sort_by
    when 'newest'
      self.reorder(created_at: :desc)
    when 'oldest'
      self.reorder(created_at: :asc)
    when 'messages'
      self.reorder(unread: :desc)
    else
      self.reorder(created_at: :desc)
    end
  end
  
  # Calculates the course's rating
  def rating_calc
    self.reviews.any? ?
      self.reviews.average(:rating).round :
      0
=begin
    # Uses IMDB's weighted rating formula
    r = self.reviews.average(:rating).to_f # average rating for this course
    n = self.reviews.count.to_f            # number of reviews for this course
    m = 5.0                                # the minimum rating needed to be considered a top-tier course
    a = Course.average(:rating).to_f       # the average ratings across all courses site-wide

    ((n / (n+m)) * r + (m / (n+m)) * a).round  # the final weighted rating
=end
  end

  # Returns the total number of downloadable resources for the course's lessons
  def resources_count
    total = 0
    if lessons.any?
      lessons.each do |lesson|
        total += lesson.resources.attachments.count if lesson.resources.attached?
      end
    end
    return total
  end

  # Returns courses with similar tags to a randomly selected course out of the given courses
  def Course.recommended(courses)
    # return self unless self.any? && self.count != Course.count
    course_sample = courses.reorder(Arel.sql('RANDOM()')).first

    sample_tags = []
    if course_sample.tags.any?
      course_sample.tags.each {|tag| sample_tags << tag.name.downcase}
    else
      sample_tags += %w[music instrument fun great]
    end
    sample_tags.map! {|sample_tag| "%#{sample_tag}%"}

    complete_query = [(['(LOWER(tags.name) LIKE ?)'] * sample_tags.length).join(' OR ')]

    # exclude original courses from which recommendations are made
    exclusion = [(['courses.id = ?'] * courses.count).join(' AND ')]
    exclusion_ids = []
    courses.each {|course| exclusion_ids << course.id}

    Course
    .left_outer_joins(:tags).where(complete_query + sample_tags)
    .where.not(exclusion + exclusion_ids)
    .where('rating > ?', '2')
    .distinct
  end

  private

  # Validates that the image is of the correct file type
  def image_file_type
    if image.attached? && !image.content_type.in?(%w[image/png image/jpeg image/gif])
      image.purge # delete the uploaded image
      errors.add(:image, 'must be a PNG, JPEG, or GIF file.')
    end
  end

  # Parse tag list
  def parse_tag_list
    if !tag_list.blank?
      arr = tag_list.split(",")
      arr.each do |name|
        tag = Tag.find_or_create_by(name: name.strip)
        if self.tags.include?(tag)
        else
          self.tags << tag
        end
      end
    else
      self.tags.clear
    end
  end

end
