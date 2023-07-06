class Api::V1::QuestionsController < Api::V1::BaseController

    def index
        puts(params)
        @quiz = Quiz.find(params["quiz_id"])
        @questions = @quiz.questions
        render json: {status: 'SUCCESS', message: 'Loaded all questions in quiz', data: @questions}, status: :ok
    end
    
    def show
        @quiz = Quiz.find(:id)
        @questions = @quiz.questions
        render json: {status: 'SUCCESS', message: 'Loaded requested question', data: @questions}, status: :ok
    end
  
    private
    def question_params
        params[:question].permit(:q_number, :question, :options, :answer, :marks, :createdAt)
    end
end

