module SessionsHelper
  def log_in(user)
    if user.class == Tutor
      session[:tutor_id] = user.id
    else
      session[:student_id] = user.id
    end
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token, user)
    digest = user.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def current_user
    if (user_id = session[:student_id])
      @current_user ||= Student.find_by(id: user_id)
    elsif (user_id = session[:tutor_id])
      @current_user ||= Tutor.find_by(id: user_id)
    elsif (user_id = cookies.signed[:student_id])
      user = Student.find_by(id: user_id)
      if user && authenticated?(:remember, cookies[:remember_token], user)
        log_in user
        @current_user = user
      end
    elsif (user_id = cookies.signed[:tutor_id])
      user = Tutor.find_by(id: user_id)
      if user && authenticated?("remember", cookies[:remember_token], user)
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  # Remembers a persistent session.
  def remember(user)
    if user.class == Student
      cookies.permanent.signed[:student_id] = user.id
    else
      cookies.permanent.signed[:tutor_id] = user.id
    end
    user.remember_token = Student.new_token
    user.update_attribute(:remember_digest, Student.digest(user.remember_token))
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget(user)
    user.update_attribute(:remember_digest, nil)
    cookies.delete(:student_id) if student?
    cookies.delete(:tutor_id) if tutor?
    cookies.delete(:remember_token)
  end

  def logged_out?
    current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:student_id) if student?
    session.delete(:tutor_id) if tutor?
    @current_user = nil
  end

  def student?
    return !current_user.nil? && (current_user.class == Student)
  end

  def tutor?
    return !current_user.nil? && (current_user.class == Tutor)
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
