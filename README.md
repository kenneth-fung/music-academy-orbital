# README

## Please Note:

- Methods added:
  - **sessions_helper**: current_user?, logged_out?
  - **models/tutor.rb**: students_unique (returns Array of Tutor's unique
    Students)
  - **application_controller.rb**: logged_in_user (for before_action filter in
    Subscriptions controller)

- Refactoring:
  - views/layouts/**_student_form**.html.erb
    & views/layouts/**_tutor_form**.html.erb =>
views/shared/**_user_form**.html.erb
  - Display of Course index refactored into views/courses/**_course**.html.erb
  - Display of Student index refactored into
    views/students/**_student**.html.erb

- views/shared/**_stats**.html.erb removed. Code for Student/Tutor moved
  into views/students/**show**.html.erb and views/tutors/**show**.html.erb
respectively
    - Previously, stats on Tutor's page redirected to Student's subscribed
      Courses. Now, Tutor has link to the Courses they are teaching.
- Course attribute/column **content** was changed from **string** to **text**.
  String has a size limit of 255, Text has a size limit of 4294967296.

## Features to Implement

### Runding

- ~~Image Upload~~
- Password Reset + Account Activation + Remember Me
- Tagging
- Chat Box

### Kenneth

- ~~Lessons~~
- Review System
- Searching and Sorting
