class Helpers

def self.valid_user?(session, params)
    if params[:username].empty?
      return "incomplete"
    elsif params[:password].empty?
      return "incomplete"
    elsif params[:email].empty?
      return "incomplete"
    else return "valid"
    end
  end

end
