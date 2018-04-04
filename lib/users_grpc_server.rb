this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'users_services_pb'

# User server
class UsersServer < Users::Service
  # create implements the create rpc method.
  def create(req, _)
    user_params = {
        first_name: req.first_name,
        last_name: req.last_name,
        email: req.email
    }
    @user = User.new(user_params)
    Response.new(user: @user)
  end

  def search(req, _)
    Helloworld::HelloReply.new(message: "Sathya welcomes you #{hello_req.name}")
  end

end

# main starts an RpcServer that receives requests to GreeterServer at the sample
# server port.
def start_grpc_server
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(UsersServer)
  s.run_till_terminated
end


#start_grpc_server