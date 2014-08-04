class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, :all

    if user.role == 'admin'
      can :manage, :all
    else
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
