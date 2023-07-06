class QuestionsController < ApplicationController

  def show
    @question = Question.find(params[:id])
    @quiz = @question.quiz if @question
    @questions = @quiz.questions
    @solve_q = SolveQuestion.get_solved(params[:quiz_id], @question.id, current_user.id)
    @result = Result.new
    Quiz.add_responder(@quiz.id, current_user.responder_id)
    respond_to do |format|
      format.js {render "show.js.haml", content_type: "text/javascript"} and return
    end
  end

  def previous
    @question = Question.previous_question(params[:quiz_id], params[:question_id])
    @quiz = @question.quiz
    @questions = @quiz.questions
    @solve_q = SolveQuestion.get_solved(params[:quiz_id], params[:question_id], current_user.id)
    respond_to do |format|
      format.html {render layout: false}
      format.js
    end
  end

  def evaluate_question
    @quiz = Quiz.find(params[:quiz_id])
    @result = Result.where(quiz_id: @quiz.id, user_id: params[:user_id]).first
    @questions = @quiz.questions
    if request.get?
      if params[:commit] == "Previous question"
        #Find the previous question for which solveQuestion object is not nil
        loop do
          @question = Question.previous_question(params[:quiz_id], params[:question_id], "Text") 
          @solved = SolveQuestion.where(question_id: @question.id, user_id: params[:user_id]).first
      break if @question.nil? || !@solved.nil?
        end
      else
        @question = @quiz.questions.where(question_type: "Text").first
        @solved = SolveQuestion.where(question_id: @question.id, user_id: params[:user_id]).first
        if @solved.nil?
          loop do
            @question = Question.next_question(params[:quiz_id], question_params[:question_id], "Text")
            @solved = SolveQuestion.where(question_id: @question.id, user_id: params[:user_id]).first
            break if @question.nil? || !@solved.nil?
          end
        end
      end
    elsif request.patch? 
      @solved = SolveQuestion.where(question_id: question_params[:question_id], user_id: params[:user_id]).first
      if params[:commit] == "Save and next"
        @solved.update(question_params)
        loop do
          @question = Question.next_question(params[:quiz_id], question_params[:question_id], "Text")
          @solved = SolveQuestion.where(question_id: @question.id, user_id: params[:user_id]).first if !@question.nil?
	          break if @question.nil? || !@solved.nil?
        end
      elsif params[:commit] == "Save"
        @solved.update(question_params)
	@question = Question.next_question(params[:quiz_id], question_params[:question_id], "Text")
      end
    end
  end

  private
  def question_params
    params[:solve_question].permit(:question_id, :ev_marks, :remark, :evaluator_id)
  end

end
