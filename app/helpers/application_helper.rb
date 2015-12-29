module ApplicationHelper
  def cp(*controller)
    "active" if controller.include?(params[:controller])
  end

  def avatar_url_by_id(user_id)
    avatar_url(User.find(user_id))
  end

  def avatar_url(user_email)
    default_url = "http://placehold.it/150x150"#"#{root_url}assets/guest.jpg"
    gravatar_id = Digest::MD5.hexdigest(user_email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

  # Shortcut for outputing proper ownership of objects,
  # depending on who is looking
  def whose?(user, object)
    case object
      when Job
        owner = current_user
      when Comment
        owner = object.user
      else
        owner = nil
    end
    if user and owner
      if user.id == owner.id
        "his"
      else
        "#{owner.name}'s"
      end
    else
      ""
    end
  end

  # Check if object still exists in the database and display a link to it,
  # otherwise display a proper message about it.
  # This is used in activities that can refer to
  # objects which no longer exist, like removed posts.
  def link_to_trackable(object, object_type)
    if object
      link_to object_type.downcase, object
    else
      "a #{object_type.downcase} which does not exist anymore"
    end
  end

  def to_b(value)
    return true if value == true || value =~ (/(true|t|yes|y|1)$/i)
    return false if value == false || value.empty? || value =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{value}\"")
  end
end
