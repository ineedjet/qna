class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can :destroy, Attachment, attachable: { user: user }
    can :set_best, Answer do |answer|
      answer.question.user == user
    end
    can :vote_del, Votable do |votable|
      votable.vote_by(user)
    end
    can [:vote_positive, :vote_negative],  Votable do |votable|
      votable.user != user && !votable.vote_by(user)
    end
    can :me, User
    can [:subscribe, :unsubscribe], Question

  end

  def admin_abilities
    can :manage, :all
  end
end
