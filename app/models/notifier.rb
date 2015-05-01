class Notifier < ActionMailer::Base

  # def register_form(user,organization,url)
  #   @user = user
  #   @organization = organization
  #   @url = url
  #   mail(
  #     subject: "Invitation Email",
  #     from: "no_reply@golaunchboard.com",
  #     to: user.email ,
  #     date: Time.now)
  # end

  def new_department_assignment(user,organization,url,department)
    @user = user
    @organization = organization
    @url = url
    @department = department
    mail(
      subject: "New Department Assignment",
      from: "no_reply@golaunchboard.com",
      to: user.email ,
      date: Time.now)
  end

  def user_invitation(email,organization,url,sender)
    @email = email
    @sender = sender
    @organization = organization
    @url = url
    mail(
      subject: "LaunchBoard Invitation",
      from: "no_reply@golaunchboard.com",
      to: email,
      date: Time.now)
  end

  def post_update(post,url)
    @post = post
    @url = url
    mail(
      subject: "Post Update",
      from: "no_reply@golaunchboard.com",
      to: post.user.email,
      date: Time.now)
  end

end
