class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :q_number, type: Integer
  field :question, type: String
  field :answer, type: String
  field :marks, type: Float
  field :question_type, type: String, default: "Multiple Choice"

  #Associations
  belongs_to :section, optional: true
  belongs_to :quiz
  belongs_to :user
  has_many :solvequestions, class_name: "SolveQuestion"
  has_many :options, inverse_of: :question, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  #Accepts current question id
  #Question type could be optional
  def self.next_question(quiz_id, question_id, type="")
    questions = Quiz.find(quiz_id).questions
    type=="" ? question = questions.where(:id.gt => question_id).first : question = questions.where(:id.gt => question_id, question_type: type).first
    question
  end

  #Accepts current question id
  #Question type could be optional
  #If previous question got nil, returns the current question
  def self.previous_question(quiz_id, question_id, type="")
    questions = Quiz.find(quiz_id).questions
    type=="" ? question = questions.where(:id.lt => question_id).last : question = questions.where(:id.lt => question_id, question_type: type).last
    question.nil? ? Question.find(question_id) : question
  end

  def self.refresh_questions(qnumb, quiz)
    qnumb += 1
    qcnt = quiz.questions.count + 1
    for i in qnumb..qcnt
      question = Question.find_by(q_number: i)
      question.q_number -= 1
      question.save
    end
  end

end
