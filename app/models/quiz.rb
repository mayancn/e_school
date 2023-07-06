class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :status, type: String, default: "In design"
  field :is_publish, type: Boolean

  #Associations
  has_many :sections
  has_many :questions
  has_many :solve_questions
  has_many :results
  has_and_belongs_to_many :evaluators, class_name: "User", inverse_of: :evaluator
    has_and_belongs_to_many :responder, class_name: "User", inverse_of: :responder
  has_and_belongs_to_many :groups
  belongs_to :user
  belongs_to :organization

  accepts_nested_attributes_for :sections, allow_destroy: true

  def self.solve_quiz(user, quiz_id)
    result = Result.where(user_id: user.id, quiz_id: quiz_id)
    result.count>=1 ? true : false
  end

  #Returns all MCQ quizzes
  #Which solved
  def self.get_mcq
    quizzes = []
    Quiz.all.each do |q|
      questions = q.questions.where(question_type: "Multiple Choice")
      quizzes.push q if q.questions.count==questions.count && q.results.count>0
    end
    quizzes
  end

  def self.add_responder(quiz_id, resp_id)
    quiz = Quiz.where(id: quiz_id).first
    quiz.responder_ids.push resp_id if !quiz.responder_ids.include?(resp_id)
    quiz.save
  end

end
