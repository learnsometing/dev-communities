# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Create Tags

languages = [ 'Java', 'C', 'C++', 'C#', 'Python', 'Visual Basic .NET',
              'PHP', 'JavaScript', 'Delphi/Object Pascal',
              'Swift', 'Perl', 'Ruby', 'Assembly', 'R', 'Visual Basic',
              'Objective C', 'Go', 'MATLAB', 'PL/SQL', 'Scratch', 'SAS', 'D', 
              'Dart', 'ABAP', 'COBOL', 'Ada', 'Fortran', 'Transact SQL', 'Lua', 
              'Scala', 'Logo', 'F#', 'Lisp', 'LabVIEW', 'Prolog', 'Haskell', 
              'Scheme', 'Groovy', 'RPG(OS/400)', 'APEX', 'Erlang', 'MQL4', 
              'Rust', 'Bash', 'Ladder', 'Logic', 'Q', 'Julia', 'Alice', 'VHDL', 
              'Awk', 'FoxPro', 'ABC', 'ActionScript', 'APL', 'AutoLISP', 'bc', 
              'BlitzMax', 'Bourne Shell', 'C shell', 'CML', 'cg', 'CL(OS/400)', 
              'Clipper Clojure', 'Common Lisp', 'Crystal', 'Eiffel', 'Elixir', 
              'Elm', 'Emacs Lisp', 'Forth', 'Hack', 'Icon', 'IDL', 'Inform', 
              'Io', 'J', 'Korn Shell', 'Kotlin', 'Maple', 'ML', 'NATURAL', 
              'NXT-G', 'OCaml', 'OpenCL', 'OpenEdge ABL', 'Oz', 'PL/I', 
              'PowerShell', 'REXX', 'Ring', 'S', 'Smalltalk', 'SPARK', 'SPSS', 
              'Standard ML', 'Stata', 'Tcl', 'VBScript', 'Verilog' ]

languages.each do |l|
  ActsAsTaggableOn::Tag.find_or_create_by(name: l)
end

# Attributes for each seed location
locations = { arlington:      { title: 'Arlington, VA, USA',
                                latitude: 38.87997,
                                longitude: -77.10677 },
              bellevue:       { title: 'Bellevue, WA, USA',
                                latitude: 47.61015,
                                longitude: -122.20152},
              fredericksburg: { title: 'Fredericksburg, VA 22401, USA',
                                latitude: 38.30318,
                                longitude: -77.46054 } }

# Information about the developers I know that I will seed the application with
devs = [{ name: 'Kyle Johnson',
          location: :arlington,
          skills: %w[Python JavaScript R] },
        { name: 'John Paschal',
          location: :arlington,
          skills: %w[JavaScript Objective\ C Python C] },
        { name: 'Kai Johnson',
          location: :bellevue,
          skills: %w[Python JavaScript Swift Go Groovy C] },
        { name: 'David Murray',
          location: :fredericksburg,
          skills: %w[PHP C Smalltalk] },
        { name: 'Matt Wilber',
          location: :fredericksburg,
          skills: %w[JavaScript] },
        { name: 'Thad Humphries',
          location: :fredericksburg,
          skills: %w[Java JavaScript C C++] },
        { name: 'Cameron Gallarno',
          location: :fredericksburg,
          skills: %w[Ruby JavaScript Kotlin] },
        { name: 'Brian Monaccio',
          location: nil,
          skills: nil },
        { name: 'Evan Ruchelman',
          location: nil,
          skills: %w[Objective\ C Swift] }]

# Create the devs
devs.each do |attributes|
  # Create a user
  email = attributes[:name].gsub(/\s+/, '').downcase + '@dev-communities.com'
  user = User.new(name: attributes[:name],
                  email: email,
                  password: 'foobar',
                  password_confirmation: 'foobar')
  user.skip_confirmation_notification!
  user.save
  user.confirm
  # Set the user's location. Evan's will be disabled from the get go. Brian's
  # will not be set for the demo.
  if attributes[:location]
    key = attributes[:location]
    location = Location.find_or_create_by(locations[key])
    UserLocation.create(user_id: user.id, location_id: location.id)
  elsif attributes[:name] == 'Evan Ruchelman'
    UserLocation.create(user_id: user.id, location_id: nil, disabled: true)
  end

  user.skill_list = attributes[:skills]
  user.save
end

# Designate some users to send friend requests.
friend_requestors = User.take(5)

# Brian will be the demo user
brian = User.find_by(name: 'Brian Monaccio')

# Send the friend requests
friend_requestors.each do |u|
  u.sent_friend_requests.create(friend: brian)
end

# Create some posts on the users with sent friend requests. When we accept 
# the request, the posts will show up in the feed.
friend_requestors.each do |u|
  5.times do
    u.posts.create(content: Faker::Lorem.paragraph(10, true, 10))
  end
end

# Designate some users to be friends with.
included_friends = User.where.not(id: friend_requestors).take(5)

# Form the friendships between the included friends and the demo user
included_friends.each do |friend|
  brian.friendships.create(friend_id: friend.id)
  # Have the friend create a post so demo user is notified of it
  friend.posts.create(content: Faker::Lorem.paragraph(10, true, 10))
end
