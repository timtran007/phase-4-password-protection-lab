class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    before_action :authorize
    
    skip_before_action :authorize, only: [:create]
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end
    
    def show
        user = User.find(session[:user_id])
        render json: user
    end

    private 
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity(invalid)
        render json: {errors: invalid.record.errors}, status: 422
    end

    def authorize
        render json: {error: "Unauthorized user"}, status: :unauthorized unless session.include? :user_id
    end
end
