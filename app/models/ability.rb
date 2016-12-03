class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.role == "admin"
        can :manage, :all 
    elsif user.role == "editor"
        can :update, Post
    elsif user.role == "user"
        can [:index_published, :show, :new, :create], Post
        cannot :edit, Post
    else
        can :read, :all
    end
  end
end
