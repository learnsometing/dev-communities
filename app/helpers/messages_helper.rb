module MessagesHelper
  def recipients_options(chosen_recipient = nil)
    s = ''
    if chosen_recipient
      s << "<option value='#{chosen_recipient.id}' data-img-src='#{chosen_recipient.profile_picture.thumb.url}' >#{chosen_recipient.name}</option>"
    else
      current_user.friends.each do |user|
        s << "<option value='#{user.id}' data-img-src='#{user.profile_picture.thumb.url}' >#{user.name}</option>"
      end
    end
    s.html_safe
  end
end
