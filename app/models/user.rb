class User < ActiveRecord::Base
  # attr_accessor :is_manager
  attr_accessor :organization_name
  attr_accessor :organization_token

  acts_as_authentic

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

  after_create :sign_up_email
  # has_many :departments, through: :department_entries

  def sign_up_email
    UserMailer.sign_up_email(self).deliver_now
  end

  def departments
    self.department_entries.map{|x| x.department_name}
  end

  def decision_departments
    self.department_entry_memberships.where(admin: true).map{|x| x.department_name}
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
      "profile_default.png"
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
