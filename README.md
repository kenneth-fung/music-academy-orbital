# README

## Please Note:

- To Fix:
  - "**password resets**" test in test/integration/**password_resets_test**.rb
    causes a redirect to **root_path** instead of **edit_password_reset_path**,
despite taking the correct token and email. However, the application itself
(in development and production) **works as intended**. Likely to do with the
test's use of **assigns**.

- Methods:
  - helpers/application_helper.rb "**find_left_off(student, course)**" =>
    helpers/subscriptions_helper.rb "**find_subscription(student, course)**"
  - Add models/subscription.rb "**update_left_off(lesson_number)**, which
    updates Subscription's left_off attribute to the given lesson_number.

## Features to Implement

### Runding

- Tagging
- Chat Box

### Kenneth

- Review System
- Course Searching and Sorting
