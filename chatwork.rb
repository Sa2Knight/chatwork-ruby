require 'net/http'
require 'uri'
require 'json'

class Chatwork

  @@API_BASE = 'https://api.chatwork.com/v2'

  # tokenを指定してオブジェクトを生成
  # tokenを省略した場合、環境変数を参照する
  def initialize(token = nil)
    @token = token || ENV['CHATWORKAPI']
  end

  # 自身のユーザ情報を取得する
  def me
    url = '/me'
    createHttpObject(url, :get)
  end

  private
    # HTTPリクエストを送信する
    def createHttpObject(url, method, params = {})
      api_uri = URI.parse(@@API_BASE + url)
      https = Net::HTTP.new(api_uri.host, api_uri.port)
      https.use_ssl = true
      req = createRequestObject(method, api_uri)
      req["X-ChatWorkToken"] = @token
      req.body = params.to_json
      https.request(req)
    end
    # リクエストオブジェクトを生成する
    def createRequestObject(method, uri)
      case method
        when :get
          return Net::HTTP::Get.new(uri.request_uri)
        when :post
          return Net::HTTP::Post.new(uri.request_uri)
        when :put
          return Net::HTTP::Put.new(uri.request_uri)
        when :delete
          return Net::HTTP::Delete.new(uri.request_uri)
      end
    end

end
