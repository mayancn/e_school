require 'json'

module Api
  module V1
    class Api::V1::SolveQuestionsController < Api::V1::BaseController
      def create
        @solved = SolveQuestion.save_answer(params[:user_answer], params[:ev_marks], params[:question_id], params[:quiz_id], params[:user_id])
        respond_to do |format|
          if @solved.save
            format.json {render :json => {message: 'Recorded input succesfully', data: @solved, status: :ok}}
            # render json: {status: 'SUCESS', message: 'succesfully'}, status: :ok
          else
            render json: {status: 'FAILED', message: 'Something went wrong'}, status: :ok
          end
        end
      end
      private
      def solved_params
          params[:solve_question].permit(:user_answer, :ev_marks, :question_id, :quiz_id, :user_id, :option_id)
      end
    end
  end
end