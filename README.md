# README

## Please Note:

### To Fix
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

### Methods
  - helpers/application_helper.rb "**find_left_off(student, course)**" =>
    helpers/subscriptions_helper.rb "**find_subscription(student, course)**"
  - Added models/subscription.rb "**update_left_off(lesson_number)**, which
    updates Subscription's left_off attribute to the given lesson_number.

### File Uploading Restrictions:
  - **Course Creation Image**: PNG, JPEG, GIF
  - **Lesson Video**: MP4, WMV
  - **Lesson Resources**: PDF, PNG, JPEG, MPEG, X-MPEG, MP3, X-MP3, MPEG3, X-MPEG3,
MPG, X-MPG, X-MPEGAUDIO

## Features to Implement

### Runding

- Tagging
- Chat Box

### Kenneth

- Review System
- Course Searching and Sorting
