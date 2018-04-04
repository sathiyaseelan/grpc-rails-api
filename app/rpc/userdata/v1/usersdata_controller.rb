require 'userdata_services_pb'
module Demo
    class UsersConroller < ::Gruf::Controllers::Base
      bind Userdata::V1::UserData::Service
  
      def create_user
        @user = UserRecord.new(user_params(request))
        
        if @user.save
            response(@user)
        else
          fail!(:internal, :validation_error, @user.errors.messages)
        end
      end

      def get_user
        if request.message.email != ''
            @user = UserRecord.find_by(email: request.message.email)
        else
            @user = UserRecord.find(request.message.id)
        end
        response(@user)
     end

     def delete_user
        if UserRecord.destroy(request.message.id)
            return Userdata::V1::DeleteResponse.new(status: true)
        else
            return Userdata::V1::DeleteResponse.new(status: false)
        end
     end

      private

      def user_params(request)
        {
            first_name: request.message.first_name,
            last_name: request.message.last_name,
            email: request.message.email
        }
      end


      def response(user)
        if user
            Userdata::V1::User.new({
                id: user.id,
                first_name: user.first_name,
                last_name: user.last_name,
                email: user.email})
        else
            fail!(:internal, :not_found, "user not found")
        end
      end
    end
  end