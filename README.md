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

## To Do

- ~~delete posts/messages~~
- ~~prevent tutor's posts/messages on their own course from counting towards their 'unread' count~~
- ~~sort student's and tutor's courses on their profile page~~
- fix home page flash message
- ~~add user names to posts/messages~~
- ~~add error messages for:~~ 
  - ~~course new/edit~~
  - ~~lesson new/edit~~
  - ~~review new/edit (on course page)~~
 
- ~~direct upload~~ **_(modification to S3 bucket needed, see below)_**
- ~~prevent downloading~~ **_(temp solution, see below)_**
- ~~check lesson video uploading issue on heroku~~
 
- ~~SSO services~~ **_(some notes, see below)_**
- ~~notification system for posts/messages~~
- ~~clickable tags~~
- ~~report function for tutors, to report other accounts that have re-uploaded their materials at a cheaper price~~
- public/private accounts for students
- recommend courses to students based on tags
- ~~payment system~~ **_(some notes, see below)_**
 
- add automated testing (rails test)
- improve UI
- seed posts/messages
 
- Ajax, json
- ~~add autocomplete function to search bar in navbar~~

#### Direct Upload

To enable direct upload to Amazon S3, go to: Your Bucket -> Permissions -> CORS configuration. Paste the following snippet in the editor and save the change.
```
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<CORSRule>
    <AllowedOrigin>*</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <MaxAgeSeconds>3000</MaxAgeSeconds>
    <AllowedHeader>Authorization</AllowedHeader>
</CORSRule>
<CORSRule>
    <AllowedOrigin>*</AllowedOrigin>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
</CORSRule>
</CORSConfiguration>
```

#### Download Prevention

Solution to prevent video downloads could be improved.
- Currently, 'download button' and 'right click & save as' methods disabled,
  but **not** on Internet Explorer.
- If time permits, change it to a system where the video gets uploaded to
  youtube/vimeo and then embedded, both automatically.

#### SSO Services

- Google available as option during sign up and log in. Tested on heroku.
  For niibori heroku, most likely just need to add RAILS_MASTER_KEY to Heroku
config, since app on Google is already set up. Ask me for key.
- Facebook not added as it requires a privacy policy.

#### Payment System
Enrolling for a course now redirects to Paypal, where the student logs in and
makes their payment to the tutor. Ideally, they should be able to pay without
having to leave Music Academy, but this requires a Paypal Pro account (costs
money). The system was not tested on heroku in full (right up until needing to
actually put money in), but it works perfectly using Paypal's provided sandbox
test accounts in development, so there is currently no reason to think it would
not work in production.

### File Uploading Restrictions
  - **Course Creation Image**: png, jpeg, gif
  - **Lesson Video**: mp4, wmv
  - **Lesson Resources**: pdf, png, jpeg, mpeg, x-mpeg, mp3, x-mp3, mpeg3, x-mpeg3, mpg, x-mpg, x-mpegaudio
