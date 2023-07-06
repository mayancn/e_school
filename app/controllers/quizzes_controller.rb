class QuizzesController < ApplicationController

  def index
    @quizzes = Quiz.where(organization_id: current_user.organization_id, :group_ids.in => current_user.group_ids, status: "Open")
  end

  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions
  end

  private
  def quiz_params
    params[:quiz].permit(:title, :is_publish, :user_id, questions_attributes: [:id, :q_number, :question, :options, :answer, :marks, :_destroy])
  end
end
