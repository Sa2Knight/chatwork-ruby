require 'net/http'

class Chatwork
  def initialize(token = nil)
    @token = token || ENV['CHATWORKAPI']
    p @token
  end
end
