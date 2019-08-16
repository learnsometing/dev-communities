# Dev-Communities

[Dev-Communities](https://dev-communities.herokuapp.com/) is my [final project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project) in [The Odin Project rails curriculum](https://www.theodinproject.com/courses/ruby-on-rails). 

Dev-Communities was created as a platform to connect developers with one another, with multiple purposes in mind:
  - Enable intuitive networking and collaboration between developers
  - Increase direct communication between developers
  - Encourage developers to keep up with each other online and in person
  
## Features
  - [Devise](https://github.com/plataformatec/devise) account registration, recovery, authentication, confirmation, and omniauth
    - Email confirmation and password reset
      - [letter opener](https://github.com/ryanb/letter_opener) used in test and development to send emails
      - SendGrid used in production
  - Google Maps and Google Places allow users to select a fixed location to use with their account. This feature can be disabled or updated as the user likes.
  - [Acts as taggable on gem](https://github.com/mbleigh/acts-as-taggable-on) used for tagging accounts with preferred programming languages. This is combined with [rails-jquery-autocomplete gem](https://github.com/risuiowa/rails-jquery-autocomplete) in searching for skills to tag.
  - User's can discover one another by name, location, or programming skill tags. Simply type your search in the search bar on the top left side of any page.
    - Jquery used to auto-complete search results
  - Posts/feed
    - Users can post to their network on their profile page. This form is submitted via AJAX so the page does not require refresh.
      - posts can be edited and deleted by their author
    - Each user has a feed - similar to facebook - where all the posts in their network are ordered by their creation time.
  - Friend requests
    - visit a user's profile and click the `Send Friend Request` button
  - Friendships
    - click `x friend requests` on the navbar and accept or decline the requests there. 
    - Friendships are formed on behalf of the requestor and the friend after a friend request is accepted
    - Friend requests are deleted when they are declined, and can be resent afterwards
  - Notification system
    - triggered when a user receives a friend request, accepts a friend request, or when a user makes a post
    - A user can view their notifications on the navbar of any page
      - separated by friend request and every other notification type
        - on the friend requests page, a user can accept or decline a request
        - on the notifications page, a user can mark a notification as read to clear it
  - [mailboxer gem](https://github.com/mailboxer/mailboxer) with chosen jquery and [ImageSelect](https://github.com/websemantics/Image-Select) for communication
## Cut Features
Some features were cut from the application in order to move on with The Odin Project. They could make it in at a later date
- Code snippets in messages
- tags linked to index page where all users with that tag displayed
- location index to see devs by location
- github account displayed on user profile
- github user information included in feed (like commits, pull requests, etc)
- events
- communities (similar to groups on facebook)
  
## Local Installation

### Requirements
- Ruby 2.6.1
- bundler
- Rails 5.2.3
- [ImageMagick](https://imagemagick.org/script/download.php) for profile picture uploads
- Postgres version 11.5 with test and development databases established
- Your google platform API key, with maps and places enabled
- An omniauth github app with the correct home page url and callback url
### Getting Started
- Clone the repository to your machine
- run `bundle install`
- update the development and test database information in `config/database.yml`. Include the databases you established for your test and development environments, along with the required username and password for each database.
- run `rails db:migrate`
- run `rails db:seed` if you would like to have some functional users to mess with
- replace the existing api key with your api key in the calls to the maps api
  - place the key between `key=` and `&libraries` in the source of the ending script tags in `app/views/user_locations/new.html.erb` and `app/views/user_locations/edit.html.erb`
  - make sure to restrict the access to your key on google cloud platform
- run `bundle exec figaro` to create an application.yml file where you can safely store secret keys. A .gitignore file will be created with the application.yml file added to it automatically
  - place your github app key and secret in this file with some convenient constant names such as 'GITHUB_APP_ID' and 'GITHUB_SECRET'
  - make sure to update the `config.omniauth :github` line in `config/initializers/devise.rb` in order to set up github omniauth
    - replace the environment variables with the names you would like to use
- make sure existing tests pass by running `rails test`
- run `rails server` to start the site on your machine
