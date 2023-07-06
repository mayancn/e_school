class Api::V1::QuizzesController < Api::V1::BaseController

    def index
        @quizzes = Quiz.all
        render json: {status: 'SUCCESS', message: 'Loaded all quizzes', data: @quizzes}, status: :ok
    end
  
    def show
        @quiz = Quiz.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Loaded requested quiz', data: @quiz}, status: :ok
    end

    private
  
    def quiz_params
        params[:quiz].permit(:title, :is_publish, :createdAt, questions_attributes: [:id, :q_number, :question, :options, :answer, :marks, :createdAt, :_destroy])
    end
end