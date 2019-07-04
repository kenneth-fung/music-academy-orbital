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

### File Uploading Restrictions:
  - **Course Creation Image**: png, jpeg, gif
  - **Lesson Video**: mp4, wmv
  - **Lesson Resources**: pdf, png, jpeg, mpeg, x-mpeg, mp3, x-mp3, mpeg3, x-mpeg3, mpg, x-mpg, x-mpegaudio

## To Do

- delete posts/messages
- fix home page flash message
- add user names to posts/messages (?)
- add error messages for: 
  - course new/edit
  - lesson new/edit
  - review new/edit (on course page)
  - empty posts & messages (on lesson page)
- ~~prevent tutor's posts/messages on their own course from counting towards their 'unread' count~~

- direct upload
- prevent downloading
- check lesson video uploading issue on heroku
- add automated testing (rails test)
- improve UI

- Ajax, json
- SSO services
