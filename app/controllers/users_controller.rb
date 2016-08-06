class UsersController < ApplicationController
  before_action :retrieve_pregnancies, only: [:add_pregnancy, :remove_pregnancy]
  rescue_from Mongoid::Errors::DocumentNotFound, with: -> { head :bad_request }

  def add_pregnancy
    current_user.add_pregnancy @pregnancy
    respond_to do |format|
      format.js { render template: 'users/refresh_pregnancies', layout: false }
    end
  end

  def remove_pregnancy
    current_user.remove_pregnancy @pregnancy
    respond_to do |format|
      format.js { render template: 'users/refresh_pregnancies', layout: false }
    end
  end

  def reorder_call_list
    # TODO: fail if anything is not a BSON id
    puts params
    current_user.update call_order: params[:order] # TODO: adjust to payload
    puts current_user.call_order
    current_user.save!
    head :ok
    # respond_to { |format| format.js }
  end

  private

  def retrieve_pregnancies
    @pregnancy = Pregnancy.find params[:id]
    @urgent_pregnancies = Pregnancy.where(urgent_flag: true)
  end

  def order_params
    params.permit(:order)
  end
end



# Started PATCH "/users/57a65435b6305eb2f48b5f87/reorder_call_list" for ::1 at 2016-08-06 18:19:57 -0400
# MONGODB | localhost:27017 | dcaf_case_management_development.find | STARTED | {"find"=>"sessions", "filter"=>{"_id"=>"Kjh3lc_-LoNg5WCou9K7ZVZ9HAY"}, "limit"=>1, "singleBatch"=>true}
# MONGODB | localhost:27017 | dcaf_case_management_development.find | SUCCEEDED | 0.000574s
# MONGODB | localhost:27017 | dcaf_case_management_development.find | STARTED | {"find"=>"users", "filter"=>{"_id"=>BSON::ObjectId('57a66244b6305ebb38dcebf3')}, "limit"=>1, "singleBatch"=>true}
# MONGODB | localhost:27017 | dcaf_case_management_development.find | SUCCEEDED | 0.000535s
# Processing by UsersController#reorder_call_list as JS
#   Parameters: {"order"=>["57a66244b6305ebb38dcebf8", "57a66244b6305ebb38dcebfa", "57a66244b6305ebb38dcebf6", "57a66244b6305ebb38dcebfc", "57a66244b6305ebb38dcebfe"], "user_id"=>"57a65435b6305eb2f48b5f87"}
# {"order"=>["57a66244b6305ebb38dcebf8", "57a66244b6305ebb38dcebfa", "57a66244b6305ebb38dcebf6", "57a66244b6305ebb38dcebfc", "57a66244b6305ebb38dcebfe"], "format"=>:js, "controller"=>"users", "action"=>"reorder_call_list", "user_id"=>"57a65435b6305eb2f48b5f87"}
