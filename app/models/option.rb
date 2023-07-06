class Option
  include Mongoid::Document

  field :option_text, type: String
  field :is_correct, type: Boolean, default: false

  #Associations
  belongs_to :question
  has_many :solvequestions, class_name: "SolveQuestion"

  def self.get_correct_options(quiz_id)
    quiz = Quiz.where(id: quiz_id).first
    question_ids = quiz.questions.pluck(:id)
    options = Option.where(:question_id.in => question_ids, is_correct: true)
    options
  end

end
