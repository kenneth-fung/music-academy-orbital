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
**models/post.rb** & **models/message.rb**
```
# Returns the user who sent the post/message
def sender
  self.user_type.constantize.find(self.user_id)
end
```
### Refactoring
Display of courses on student/tutor courses page, as well as home page, moved
out of course index page and into their own pages.
Student/tutor show pages moved to shared/_user_show.

### File Uploading Restrictions:
  - **Course Creation Image**: png, jpeg, gif
  - **Lesson Video**: mp4, wmv
  - **Lesson Resources**: pdf, png, jpeg, mpeg, x-mpeg, mp3, x-mp3, mpeg3, x-mpeg3, mpg, x-mpg, x-mpegaudio

## To Do

- ~~delete posts/messages~~
- ~~prevent tutor's posts/messages on their own course from counting towards their 'unread' count~~
- sort tutor's courses by unread
- fix home page flash message
- add user names to posts/messages (?)
- add error messages for: 
  - course new/edit
  - lesson new/edit
  - review new/edit (on course page)
  - empty posts & messages (on lesson page)
 
- ~~direct upload~~
- ~~prevent downloading~~ **_(temp solution, see below)_**
- ~~check lesson video uploading issue on heroku~~
 
- SSO services
- ~~notification system for posts/messages~~
- clickable tags
- public/private accounts for students
- recommend courses to students based on tags
- payment system
 
- add automated testing (rails test)
- improve UI
- seed posts/messages
 
- Ajax, json

Solution to prevent video downloads could be improved.
- Currently, 'download button' and 'right click & save as' methods disabled,
  but **not** on Internet Explorer.
- If time permits, change it to a system where the video gets uploaded to
  youtube/vimeo and then embedded, both automatically.
