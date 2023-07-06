class Admin::QuestionsController < ApplicationController

  def index
    @quiz = Quiz.find(question_params[:quiz_id])
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @quiz = Quiz.find(@question.quiz.id)
  end

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @question = Question.new(quiz_id: @quiz.id)
    @question.options.build
    @question.options.build
  end

  def create
    @question = Question.new(question_params)
    @quiz = @question.quiz
    respond_to do |format|
      if @question.save
        if params[:commit] == "Save and add another"
          format.html {redirect_to new_admin_quiz_question_path(@quiz), notice:"Question Saved Successfully" }
        else
          format.html {redirect_to admin_quiz_path(@quiz), notice:"Question Saved Successfully" }
        end
      else
        @question.options.build
        @question.options.build
        format.html {render "new"}
      end
    end
  end

  def edit
    @question = Question.find(params[:id])
    @quiz = @question.quiz
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update(question_params)
        if params[:commit] == "Save and next"
	@question = Question.next_question(@question.quiz.id, @question.id)
          format.html {redirect_to edit_admin_question_path(@question), notice:"Question Saved Successfully" }
        elsif params[:commit] == "Save and previous"
	@question = Question.previous_question(@question.quiz.id, @question.id)
          format.html {redirect_to edit_admin_question_path(@question), notice:"Question Saved Successfully" }
        else
          format.html {redirect_to admin_question_path(@question), notice:"Question Saved Successfully" }
        end
      else
        format.html{render 'edit', notice:"Please fill all the fields properly"}
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    quiz = @question.quiz
    qnum = @question.q_number
    @question.destroy
    if @question.destroy
      Question.refresh_questions(qnum, quiz)
    end
    redirect_to admin_quiz_path(@question.quiz_id) , notice:"Question removed successfully"
  end

  private
  def question_params
    if params[:question][:question_type] == "Multiple Choice"
      params[:question].permit(:q_number, :question, :options, :answer, :question_type, :marks, :quiz_id, :user_id, options_attributes: [:id, :option_text, :is_correct]) 
    else
      params[:question].permit(:q_number, :question, :options, :answer, :question_type, :marks, :quiz_id, :user_id)
    end
  end
end
