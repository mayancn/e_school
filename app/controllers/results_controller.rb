class ResultsController < ApplicationController

  def index
    @results = Result.all
  end

  def show
    @result = Result.find(params[:id])
  end

  def new
    @result = Result.new
  end

  def create
    @result = Result.new(result_params)
    @result.total=Result.get_quiz_total(@result.quiz.id, current_user.id)
    @result.percentage=Result.get_percentage(@result.quiz.id, @result.total)
    respond_to do |format|
      if @result.save
        SolveQuestion.add_result(@result.quiz.id, @result.id, current_user.id)
        format.html{redirect_to result_path(@result), notice:"Result Submited"}
      else
        format.html{render "new", notice:"Please fill all the fields carefully"}
      end
    end
  end

  def edit
    @result = Result.find(params[:id])
  end

  def update
    @result = Result.find(params[:id])
    respond_to do |format|
      if @result.update(result_params)
        @result.total=Result.get_quiz_total(@result.quiz.id, current_user.id)
        @result.percentage=Result.get_percentage(@result.quiz.id, @result.total)
        @result.save
        format.html{redirect_to result_path(@result), notice: "Result is Updated"}
      else
        format.html{render "edit", notice:"Please fill all the fields carefully"}
      end
    end
  end

  def delete
    @result = Result.find(params[:id])
    @result.destroy
    if @result == nil
      redirect_to results_path, notice:"Result is no longer available"
    end
  end

private
  def result_params
    params[:result].permit(:heading, :description, :total, :grade, :status, :quiz_id, :user_id)
  end

end
