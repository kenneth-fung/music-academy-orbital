# README

## Please Note:

### To Fix
Pagination no longer working entirely as expected for lessons in production
(Heroku). The first lesson of each course is displayed repeatedly for the first 1 to
4 pages when paginated. Without pagination (i.e. all lessons are displayed on
the course page), the lessons are displayed correctly. Will need to change
method of lesson display.
    
"**password resets**" test in test/integration/**password_resets_test**.rb
throws an error on line 20.

Line 20:
```
assert_not_equal @user.reset_digest, @user.reload.reset_digest
```

The error:
```
Expected nil to not be equal to nil.
```

### New Methods
**helpers/sessions_helper.rb**
```
def subscribing?(course)
  student? && current_user.subscribing?(course)
end

def course_owner?(course)
  tutor? && current_user?(course.tutor)
end
```
**models/course.rb** now has **Course.search(query)**, where query is a string
parameter.

### UI Changes
- Create Course button moved to tutor's profile
- My Courses (Student/Tutor) moved to profile page
- My Students moved to profile page

### File Uploading Restrictions:
  - **Course Creation Image**: png, jpeg, gif
  - **Lesson Video**: mp4, wmv
  - **Lesson Resources**: pdf, png, jpeg, mpeg, x-mpeg, mp3, x-mp3, mpeg3, x-mpeg3, mpg, x-mpg, x-mpegaudio

## To Do

### Runding

- Tagging
- Chat Box

### Kenneth

- Review System
- Course Searching and Sorting
