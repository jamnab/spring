class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is_admin?
      can :manage, :all
    else
      # Users

      # Organizations

      # Posts

      # Comments

      # Opinions
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
