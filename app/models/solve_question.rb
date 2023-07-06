class SolveQuestion
  include Mongoid::Document

  field :user_answer, type: String
  field :ev_marks, type: Float
  field :remark, type: String

  #Association
  belongs_to :question
  belongs_to :quiz
  belongs_to :user
  belongs_to :option, optional: true
  belongs_to :result, optional: true
  belongs_to :evaluator, optional: true, class_name: "User"

  def self.save_answer(user_answer, question_id, quiz_id, user_id, solved_question_id=nil)
    if solved_question_id.nil?
      solved = SolveQuestion.new(user_answer: user_answer, question_id: question_id, quiz_id: quiz_id, user_id: user_id)
    else
      solved = SolveQuestion.where(id: solved_question_id).first
      solved.user_anser = user_anser
    end
    solved.save ? true : false
  end

  def self.get_solved(quiz_id, question_id, user_id)
    solved = SolveQuestion.where(quiz_id: quiz_id, question_id: question_id, user_id: user_id).first
    if solved.nil?
      solved = SolveQuestion.new
    else
      solved
    end
  end

  #Question type is optional
  def self.get_all_solved(quiz_id, user_id, type="")
    quiz = Quiz.where(id: quiz_id).first
    question_ids = type == "" ? quiz.questions.pluck(:id) : quiz.questions.where(question_type: type).pluck(:id)
    solved = SolveQuestion.where(:question_id.in => question_ids, user_id: user_id)
    solved
  end

  #Adds result id to the solved question
  def self.add_result(quiz_id, result_id, user_id)
    s_questions = SolveQuestion.get_all_solved(quiz_id, user_id)
    s_questions.each do |q|
      q.result_id=result_id
      q.save
    end
  end

end
