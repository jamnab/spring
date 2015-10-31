class Ability
  include CanCan::Ability

  def initialize(user)
    @cr = [:read, :create]
    @cru = [:read, :create, :update]
    @crud = [:read, :create, :update, :destroy]

    can :create, User
    can :join_by_code, Organization

    can :create, BetaSignUp

    user ||= User.new

    if user.is_admin?
      can :manage, :all
    else
      # Users
      can @cru, User do |u|
        user == u
      end

      # Organizations
      can @cru, Organization do |org|
        user.manager && user.organization == org
      end

      can [:update_departments, :manage_users], Organization do |org|
        user.manager && user.organization == org
      end

      # Posts
      can @crud, Post do |post|
        !post.approved && post.user == user
      end
      can [:update, :judge], Post do |post|
        !post.approved && user.manager && user.organization == post.organization
      end
      can [:update, :judge], Post do |post|
        !post.approved && !(post.departments & user.decision_departments).empty?
      end
      can @cr, Post do |post|
        post.organization == user.organization
      end

      # Comments
      can @crud, Comment do |com|
        com.user == user
      end
      can @cr, Comment do |com|
        com.commentable.try(:organization) == user.organization
      end
      can :filter_sort, Comment do |com|
        com.commentable.try(:organization) == user.organization
      end

      # Misc models that are not guarded
      # Opinions
      # Favourite
      # Picture
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
