class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == ADMIN
      can :manage, :all
    elsif user.role == TEACHER
      can :read, Quiz
      can :read, Question
      can :manage, Admin::Quiz, user_id: user.id
      can :manage, Admin::Question, user_id: user.id
      can [:read ,:update], SolveQuestions
      can :manage, Result
      can :read, User, user_role: user.role=="student"||user.role=="guest"
    elsif user.role == STUDENT
      can :read, Quiz
      can :read, Question
      can [:create, :update], SolveQuestions, user_id: user.id
      can :read, Result, user_id: user.id
    elsif user.role == GUEST
      can :read, Quiz
      can :read, Question
      can [:create, :update], SolveQuestions, user_id: user.id
      can :read, Result, user_id: user.id
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    end
  end
end
