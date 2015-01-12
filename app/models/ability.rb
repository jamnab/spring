class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is_admin?
      can :manage, :all
    else
      # Users
      can :manage, User do |u|
        user == u
      end

      # Organizations

      # Posts

      # Comments

      # Opinions
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
