class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
  # customize here
  def exclude?
    bot? || request.ip == "192.168.1.1"
  end

end