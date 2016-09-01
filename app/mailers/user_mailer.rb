class UserMailer < ApplicationMailer
  default from: "do-not-reply@golaunchboard.com"

  def sign_up_email(user)
    @user = user
    mail(subject: 'Welcome to Launchboard', to: @user.email)
  end

  def invite_email(organization, target_email)
    @organization = organization
    mail(subject: 'You have been invited to join Launchboard', to: target_email)
  end

  def daily_digest(user)
    # todo: get notifications of today
    notifications_to_compile = user.notifications.where(to_compile: true, created_at: (Date.today.beginning_of_day .. Date.today.end_of_day))
    mail(
      subject: "Portfolio10 Daily Digest: #{Time.now.strftime("%b %d, %Y")}",
      to: user.email
    )
  end

  def new_notification(type, context, email = 'do-not-reply@golaunchboard.com')
    # type, context model
    # => 'new_post_view', Post
    # => 'new_post_pending', Post
    # => 'new_comment', Comment
    # => 'post_verdict', Post
    # => 'new_launched_post', Post
    # => 'action_date', Post
    # build: @message_title, @body_text, @link
    user = User.where(email: email).first
    if type == 'new_post_view'
      @post = context
      @message_title = "New Idea"
      @body_text = "A new idea #{context.title} was posted in your departments."
      @link = post_url(@post)
      @emails = @post.department_entries.collect do |de|
        de.users.map(&:email)
      end.flatten

    elsif type == 'new_post_pending'
      @post = context
      @message_title = "New Idea Pend Approval"
      @body_text = "A new idea #{context.title} was posted in your departments and pending your approval."
      @link = post_url(@post)
      @emails = @post.department_entries.collect do |de|
        de.managers.map(&:email)
      end.flatten
    elsif type == 'new_comment'
      if user && user == context.commentable.user
        @message_title = "New Comment on Your Idea"
      else
        @message_title = "New Comment on a Post You Upvoted"
      end
      @body_text = "A new comment by #{context.user.full_name} was posted on #{context.commentable.title}."
      @link = post_url(context.commentable)
      # TODO: @emails = ? refer to the example above
    elsif type == 'post_verdict'
      if context.approved
        verdict = 'approved'
      elsif context.graveyard
        verdict = 'rejected'
      end
      @message_title = "Your Idea was #{verdict.capitalize}"
      @body_text = "Your idea #{context.title} was #{verdict} for listing."
      @link = post_url(context)
      @emails = [context.user.email]
    elsif type == 'new_launched_post'
      if user && user == context.user
        @message_title = "Your Idea was Launched!"
        @body_text = "Your idea #{context.title} was launched!"
      else
        @message_title = "New Launched Idea!"
        @body_text = "A new idea #{context.title} was launched in your departments!"
      end
      @link = post_url(context)
      # TODO: @emails = ?
    elsif type == 'action_date'
      @message_title = "New Action Date"
      @body_text = "A manager has set an action date (#{context.action_date.strftime('%b %d, %Y')}) for your idea #{context.title}."
      @link = post_url(context)
      # TODO: @emails = ?
    else
      # unknown, do nothing
    end

    @emails = [email] if @emails.blank?

    mail(
      subject: @message_title,
      to: @emails
    )
  end
end

