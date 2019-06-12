module SessionsHelper
  def log_in_student(student)
    session[:student_id] = student.id
  end

  def log_in_tutor(tutor)
    session[:tutor_id] = tutor.id
  end

  def current_user
    if session[:student_id]
      @current_user ||= Student.find_by(id: session[:student_id])
    elsif session[:tutor_id]
      @current_user ||= Tutor.find_by(id: session[:tutor_id])
    end
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_out?
    current_user.nil?
  end

  def log_out
    session.delete(:student_id)
    session.delete(:tutor_id)
    @current_user = nil
  end

  def student?
    return current_user.class == Student.first.class
  end

  def tutor?
    return current_user.class == Tutor.first.class
  end
end
