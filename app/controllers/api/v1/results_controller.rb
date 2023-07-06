class Api::V1::ResultsController < Api::V1::BaseController

    def index
        puts(params)
        @results = Result.find(params["user_id"])
        render json: {status: 'SUCCESS', message: 'Loaded all results for user', data: @results}, status: :ok
    end
    
    def show
        @result = Result.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Loaded result', data: @result}, status: :ok
    end
    
    def new
        @result = Result.new
        
    end
    
    def create
        @result = Result.new(result_params)
        respond_to do |format|
        if condition
            render json: {status: 'SUCCESS', message: 'Result is printed', data: @result}, status: :ok
        else
            render json: {status: 'Bad Request', message: 'Please fill all the fields carefully'}, status: 400
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
                render json: {status: 'SUCCESS', message: 'Result is updated', data: @result}, status: :ok
            else
                render json: {status: 'Bad Request', message: 'Please fill all the fields carefully'}, status: 400
            end
        end
    end
    
    def delete
        @result = Result.find(params[:id])
        @result.destroy
        if @result == nil
            render json: {status: 'SUCCESS', message: 'Result deleted', data: @result}, status: :ok
        end
    end

    def get_by_user
    end

    def get_by_quiz
		end
		
		def get_for_user
    end

    private
    def result_params
        params[:result].permit(:heading, :description, :total, :grade, :quiz_id , :user_id , :solve_question_id)
    end

end