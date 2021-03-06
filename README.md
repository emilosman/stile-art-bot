# STILE art bot
The app selects randomly from a pool of images and tweets them out.  
Intended to automate art accounts.  
Drag & drop upload for easy gallery management.

Sign in with Twitter OAuth and automate an unlimited number of accounts.

## How to use
[![example video](https://img.youtube.com/vi/aSjfVGTu1LQ/0.jpg)](https://www.youtube.com/watch?v=aSjfVGTu1LQ)  

1. Sign in with the Twitter account you want to automate
2. Drag & drop the images from a folder onto the the upload field
3. That's it!

The file names will appear under the images.  
This will be in the tweet text. You may modify the text to whatever you want in the textbox.

## Tweeting logic
Here are the rules for selecting images to tweet out:
- it shouldn't post the same image twice in a row
- if there are enough images, it'll try not to repeat for a month
- when you add new images later, they will be prioritised as the next ones to tweet out

## Examples of bot rake tasks

### Tweet a random artwork on a specific account
`rake 'tweets:post_random_artwork[TWITTER_USERNAME_HERE]'`

### Tweet random artwork using all bots
`rake 'tweets:post_random_all_bots'`

## Development
Created with Ruby on Rails and Vue.js.  
Forked from [emilosman/moonboard](https://github.com/emilosman/moonboard)
