class SolveQuestionsController < ApplicationController
  def create
    @solved = SolveQuestion.new(solved_params)
    respond_to do |format|
      if @solved.save
        @question = Question.next_question(solved_params[:quiz_id], solved_params[:question_id])
	@quiz = @question.quiz if @question
	        @solve_q = SolveQuestion.new
		@questions = @quiz.questions if @quiz
        format.js
      else
        format.html {render "new"}
      end
    end
  end

      def update
    @solved = SolveQuestion.find(params[:id])
    respond_to do |format|
      if @solved.update(solved_params)
        @question = Question.next_question(solved_params[:quiz_id], solved_params[:question_id])
	@quiz = @question.quiz
        @solve_q = SolveQuestion.get_solved(@question.quiz.id, @question.id, current_user.id)
	@questions = @quiz.questions
        format.js
      else
        format.html render "edit"
      end
    end
      end

    private
    def solved_params
        params[:solve_question].permit(:user_answer, :ev_marks, :question_id, :quiz_id, :user_id, :option_id)
    end
end
