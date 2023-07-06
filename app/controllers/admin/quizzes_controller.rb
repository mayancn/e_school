class Admin::QuizzesController < ApplicationController

  def index
    @quizzes = current_user.organization.quizzes
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    respond_to do |format|
      if @quiz.save
        format.html {redirect_to admin_quiz_path(@quiz), notice: "Quiz created Successfully"}
      else
        format.html {render "new"}
      end
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    q_params = quiz_params
    evaluator_ids = q_params[:evaluator_ids]
    evaluator_ids.delete(1) if !evaluator_ids.nil? && evaluator_ids[0] == ""
    q_params[:evaluator_ids] = evaluator_ids
    respond_to do |format|
      if @quiz.update(q_params)
        format.html {redirect_to admin_quiz_path(@quiz.id), notice: "Quiz updated Successfully"}
      else
        format.html {render "edit", notice:"Please fill all the fields carefully"}
      end
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy
    redirect_to admin_quizzes_path , notice:"Quiz has been destroyed and is no longer available"
  end

  def analyze
    @quiz = Quiz.find(params[:quiz_id])
  end

  def assign_evaluators
    @quiz = Quiz.find(params[:quiz_id])
    @evaluators = User.where(:evaluator_id.ne => nil)
    @a_evaluators = Array.new
    @evaluators.each do |e|
      @a_evaluators.push [e.evaluator_id, e.name]
    end
  end

  def evaluate_quiz
    @quiz = Quiz.find(params[:quiz_id])
    @users = User.where(:responder_id.in => @quiz.responder_ids)
  end

  def publish_quiz
    if request.get?
      @quiz = Quiz.find(params[:quiz_id])
    elsif request.patch?
      @quiz = Quiz.find(params[:quiz_id])
      if @quiz.update(quiz_params)
        redirect_to admin_quizzes_path
      end
    end
  end

  private
  def quiz_params
    params[:quiz].permit(:title, :is_publish, :user_id, :organization_id, :status, questions_attributes: [:id, :q_number, :question, :options, :answer, :marks, :_destroy], evaluator_ids: [], group_ids: [])
  end

end