module SessionsHelper
  def log_in_student(student)
    session[:student_id] = student.id
  end

  def log_in_tutor(tutor)
    session[:tutor_id] = tutor.id
  end

  def remember(user)
    if student?
      user.remember_token = Student.new_token
      user.update_attribute(:remember_digest, Student.digest(user.remember_token))
      cookies.permanent.signed[:student_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    elsif tutor?
      user.remember_token = Tutor.new_token
      user.update_attribute(:remember_digest, Tutor.digest(user.remember_token))
      cookies.permanent.signed[:tutor_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token, user)
    return false if user.remember_digest.nil?
    BCrypt::Password.new(user.remember_digest).is_password?(remember_token)
  end

  def current_user
    if (user_id = session[:student_id])
      @current_user ||= Student.find_by(id: user_id)
    elsif (user_id = session[:tutor_id])
      @current_user ||= Tutor.find_by(id: user_id)

    elsif (user_id = cookies.signed[:student_id])

      user = Student.find_by(id: user_id)
      if user && authenticated?(cookies[:remember_token], user)
        log_in_student user
        @current_user = user
      end

    elsif (user_id = cookies.signed[:tutor_id])

      user = Tutor.find_by(id: user_id)
      if user && authenticated?(cookies[:remember_token], user)
        log_in_tutor user
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

end
