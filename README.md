# README

## Please Note:

- **current_user?**, **logged_out?** methods added to **sessions_helper**
- **students_unique** method added to Tutor model (returns Array of unique
  Students for this Tutor)
- **logged_in_user** method added to **application_controller.rb**, used as
  **before_action** filter in Subscriptions controller
- **app/views/shared/_stats.html.erb removed**. Code for Student/Tutor moved into
  **app/views/students/show.html.erb** and **app/views/tutors/show.html.erb**
respectively
- **app/views/layouts/_student_form.html.erb** and
  **app/views/layouts/_tutor_form.html.erb** refactored into
**app/views/shared/_user_form.html.erb**

## Features to Implement

### Collaborative

- Image Upload

### Runding

- Password Reset + Account Activation + Remember Me
- Tagging
- Chat Box

### Kenneth

- Lessons
- Review System
- Searching and Sorting
