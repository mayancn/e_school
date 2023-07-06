class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: String
  field :heading, type: String
  field :description, type: String
  field :total, type: Float, default: 0
  field :grade, type: String
  field :percentage, type: Float, default: 0

  #Associations
  belongs_to :user
  belongs_to :quiz
  has_many :solve_questions, class_name: "SolveQuestion"

    def self.get_quiz_total(quiz_id, user_id)
    s_questions = SolveQuestion.get_all_solved(quiz_id, user_id)
    total=0
    s_questions.each do |s|
      if s.question.question_type == "Multiple Choice"
        c_option = s.question.options.where(is_correct: true).first
        total+=s.question.marks if s.option==c_option
      elsif s.question.question_type == "Text" && !s.evaluator_id.nil?
        total+=s.ev_marks
      elsif s.question.question_type == "Match"
        total+=s.question.marks if s.user_answer == s.question.answer
      end
    end
    total
    end

  def self.get_percentage(quiz_id, quiz_total)
    q_marks = Quiz.where(id: quiz_id).first.questions.pluck(:marks)
    total = 0
    q_marks.each do |m|
      total=total+m
    end
    percentage = quiz_total/total*100
    percentage
  end

  def self.get_quiz_grade(quiz_id, total)

  end

end
