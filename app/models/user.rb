# :admin is the flag to determine if user is an admin for launchboard
# :manager is the flag to determine if user is a manager for the organization he
# belongs to
class User < ActiveRecord::Base
  # attr_accessor :is_manager
  attr_accessor :organization_name
  attr_accessor :organization_token

  acts_as_authentic

  searchkick match: :word_start, searchable: [:email]

  has_many :posts
  has_many :comments
  # has_many :received_comments, through: :posts, class_name: 'Comment'
  has_many :opinions
  has_many :voted_posts, through: :opinions, source_type: 'Post', source: :opinionable
  # has_many :received_opinions, through: :posts, class_name: 'Opinion'

  has_one :picture
  accepts_nested_attributes_for :picture
  has_many :favourites
  has_many :fav_posts, through: :favourites
  has_many :notifications
  has_many :activities,:class_name => "PublicActivity::Activity", through: :notifications
  has_many :email_notification_settings
  # has_many :project_memberships, dependent: :destroy
  # has_many :projects, through: :project_memberships

  belongs_to :organization

  has_many :department_entry_memberships, dependent: :destroy
  has_many :department_entries, through: :department_entry_memberships

  # user can send multiple external invites
  has_many :user_invites

  after_create :sign_up_email
  # has_many :departments, through: :department_entries


  ## => Email Notification Settings field (string of digits)
  ## 0 -> Never, 1 -> Instant, 2 -> Compile to EoD
  ##  setting_id => setting
  ## NEVER change the order, ALAWAYS ADD TO END
  NOTIFICATION_TYPES = []
  NOTIFICATION_TYPES[0]  = "new idea in your department for view"
  NOTIFICATION_TYPES[1]  = "new idea pending approval (for managers)"
  NOTIFICATION_TYPES[2]  = "new comment on your idea post"
  NOTIFICATION_TYPES[3]  = "new comment on an idea you upvoted"
  NOTIFICATION_TYPES[4]  = "your idea was approved for listing"
  NOTIFICATION_TYPES[5]  = "your idea was rejected for listing"
  NOTIFICATION_TYPES[6]  = "an action date was set for your launched idea"
  NOTIFICATION_TYPES[7]  = "your idea was launched"
  NOTIFICATION_TYPES[8]  = "new launched idea in your department"
  NOTIFICATION_DEFAULT = "210011211"

  def get_notification_setting(notification_type)
    if self.notification_settings.nil?
      self.update(notification_settings: User::NOTIFICATION_DEFAULT)
    end

    if self.notification_settings.length < notification_type
      # default end of day
      return '2'
    else
      return self.notification_settings[notification_type - 1]
    end
  end

  def process_email_notification(notification_type, n)
    # send right away, add to_compile, or muck
    ns = self.get_notification_setting(notification_type)
    if ns == '0'
      # muck, do nothing
    elsif ns == '1'
      # send now
      case notification_type
        when 0
          UserMailer.new_notification('new_post_view', n.activity.trackable).deliver_now
        when 1
          UserMailer.new_notification('new_post_pending', n.activity.trackable).deliver_now
        when 2    # same as 3
        when 3
          # TODO, default never
        when 4    # same as 5
        when 5
          UserMailer.new_notification('post_verdict', n.activity.trackable).deliver_now
        when 6
          UserMailer.new_notification('action_date', n.activity.trackable).deliver_now
        when 7    # same as 8
        when 8
          UserMailer.new_notification('new_launched_post', n.activity.trackable).deliver_now
      end
    elsif ns == '2'
      # add to_compile
      n.update(to_compile: true)
    else
      # unknown, do nothing
    end
  end

  def sign_up_email
    UserMailer.sign_up_email(self).deliver_now
  end

  def departments
    self.department_entries.map{|x| x.department_name}
  end

  def decision_departments
    if self.manager
      self.organization.departments
    else
      self.department_entry_memberships.where(admin: true).map{|x| x.department_name}
    end
  end

  def decision_department_entries
    if self.manager
      self.organization.department_entries
    else
      self.department_entry_memberships.where(admin: true).map{|x| x.department_entry}
    end
  end

  # has_one :organization_membership, dependent: :destroy
  # has_one :organization, through: :organization_membership

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def is_manager?
    self.manager
  end

  def is_admin?
    self.admin
  end

  def profile_image_url
    if self.picture.nil?
      "profile-icon.png"
    else
      self.picture.image.url(:user_image)
    end
  end

  def contribution
    # number of opinions given
    {'total' => self.opinions.count,
     'positive' => self.opinions.like.count,
     'negative' => self.opinions.dislike.count }
  end

  def impact
    # overall received opinions
    opinions_from_posts = Opinion.where(positive: true) \
      .joins( "INNER JOIN `posts` ON `opinions`.`opinionable_id` = `posts`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Post' } ) \
      .where( :posts => { user_id: self.id } )

    opinions_from_comments = Opinion \
      .joins( "INNER JOIN `comments` ON `opinions`.`opinionable_id` = `comments`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Comment' } ) \
      .joins( "INNER JOIN `posts` ON `comments`.`commentable_id` = `posts`.`id`" ) \
      .where( :comments => { commentable_type: 'Post' } ) \
      .where( :posts => { user_id: self.id} )

    {'total' => opinions_from_posts.count + opinions_from_comments.count,
     'positive' => opinions_from_posts.like.count + opinions_from_comments.like.count,
     'negative' => opinions_from_posts.dislike.count + opinions_from_comments.dislike.count }
  end

  def performance_by_post_type(post_type)
    # contribution
    contribution_from_posts = Opinion.where(user_id: self.id) \
      .joins( "INNER JOIN `posts` ON `opinions`.`opinionable_id` = `posts`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Post' } ) \
      .where( :posts => { post_type: post_type } ).count

    contribution_from_comments = Opinion.where(user_id: self.id) \
      .joins( "INNER JOIN `comments` ON `opinions`.`opinionable_id` = `comments`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Comment' } ) \
      .joins( "INNER JOIN `posts` ON `comments`.`commentable_id` = `posts`.`id`" ) \
      .where( :comments => { commentable_type: 'Post' } ) \
      .where( :posts => { post_type: post_type } ).count

    contribution = contribution_from_posts + contribution_from_comments

    # impact
    impact_from_posts = Opinion.where(positive: true) \
      .joins( "INNER JOIN `posts` ON `opinions`.`opinionable_id` = `posts`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Post' } ) \
      .where( :posts => { user_id: self.id, post_type: post_type } ).count

    impact_from_comments = Opinion \
      .joins( "INNER JOIN `comments` ON `opinions`.`opinionable_id` = `comments`.`id`" ) \
      .where( :opinions => { opinionable_type: 'Comment' } ) \
      .joins( "INNER JOIN `posts` ON `comments`.`commentable_id` = `posts`.`id`" ) \
      .where( :comments => { commentable_type: 'Post' } ) \
      .where( :posts => { user_id: self.id, post_type: post_type } ).count

    impact = impact_from_posts + impact_from_comments

    # performance = contribution['total'] + impact['positive']
    performance = contribution + impact

    { 'contribution' => contribution,
      'positive_impact' => impact,
      'performance' => performance }
  end
end
