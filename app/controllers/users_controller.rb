class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

    def index
      # @users = User.
      # @Trees = Tree
      @trees = [
        {name:"Broncos", id:110, type:"Apple Tree", location:"Santa Clara City Library", latitude:37.3446167260408,longitude:-121.932690069077, age:10},
        {name:"Apple", id:110, type:"Palm Tree", location:"Santa Clara City Library", latitude:37.350266893316,longitude:-121.94374592494, age:20},
        {name:"Tony", id:110, type:"Orange Tree", location:"Santa Clara City Library", latitude:37.3392813,longitude:-121.9382831, age:30},
        {name:"SuperMike", id:110, type:"Junkrat Tree", location:"Santa Clara City Library", latitude:37.345256,longitude:-121.935864, age:40},
        {name:"LULU", id:110, type:"LULU Tree", location:"Santa Clara City Library", latitude:37.348655,longitude:-121.946166, age:50}
      ]
    end

    def new
      @user = User.new
    end

    def show
    	@user = User.find(params[:id])

    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:success] = "success!! Welcome to Trees Go Community"
        redirect_to @user
      else
        flash.now[:danger] = "sign up fails"
        render 'new'
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash.now[:success] = "Update successfully"
        redirect_to @user
      else
        render 'edit'
      end
    end


    def destroy
       User.find(params[:id]).destroy
          flash[:success] = "User deleted"
          redirect_to users_url
    end



    def following
      @title = "Following"
      @user  = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    end

    def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    end

    private
    #rails 不允许用户直接在params上操作，通过这个方法限定params以防出现问题。
      def user_params
        params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
      end

      def correct_user
        #这个id是怎么获取到的呢？？？？？
        @user = User.find(params[:id])
        redirect_to(root_url) && flash[:danger] = "action rejected" unless current_user?(@user)
      end

      def admin_user
        redirect_to (users_url) unless current_user.admin?
      end

end
