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
 tag = ActsAsTaggableOn::Tag.find_or_create_by(name: l)
end

# Developers I know grouped by location

devs_by_location = { arlington:      ['Kyle Johnson', 'John Paschal'],
                     bellevue:       ['Kai Johnson'],
                     fredericksburg: ['David Murray', 'Matt Wilber', 
                                      'Thad Humphries', 'Michael Pastore',
                                      'Cameron Gallarno'],
                     stafford:       ['Brian Monaccio', 'Evan Ruchelman']
                   }

# The location information of the above developers
locations = { arlington:      { title: 'Arlington, VA, USA',
                                latitude: 38.87997,
                                longitude: -77.10677 },
              bellevue:       { title: 'Bellevue, WA, USA',
                                latitude: 47.6101497,
                                longitude: -122.2015159},
              fredericksburg: { title: 'Fredericksburg, VA 22401, USA',
                                latitude: 38.3031837,
                                longitude: -77.46053990000001 },
              stafford:       { title: 'Stafford, VA 22554, USA',
                                latitude: 38.4220687,
                                longitude: -77.4083086 } }

# Create each location
locations.values.each do |attributes|
  location = Location.create(attributes)
end

# Create the devs
devs_by_location.each do |location, devs_by_name|
  devs_by_name.each do |dev_name|
    email = dev_name.gsub(/\s+/, '').downcase + '@dev-communities.com'
    new_user = User.new(name: dev_name, email: email, 
                          password: 'foobar', password_confirmation: 'foobar')
    new_user.skip_confirmation_notification!
    new_user.save
    new_user.confirm
    
    # Get the right location for each dev 
    location_id = Location.find_by(title: locations[location][:title]).id
    UserLocation.create(user_id: new_user.id, location_id: location_id)
    new_user.user_location.disable if new_user.name = 'Evan Ruchelman'
  end
end

# Designate some users to send friend requests.
friend_requestors = User.take(5)

# Designate an admin user
admin = User.find_by(name: 'Brian Monaccio')

# Send the friend requests
friend_requestors.each do |u|
  u.sent_friend_requests.create(friend: admin)
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

# Form the friendships between the included friends and the admin
included_friends.each do |friend|
  admin.friendships.create(friend_id: friend.id)
  # Have the friend create a post so admin is notified of it
  friend.posts.create(content: Faker::Lorem.paragraph(10, true, 10))
end
