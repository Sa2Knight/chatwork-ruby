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
    res = createHttpObject(url, :get)
    return JSON.parse(res.body)
  end

  # 自身の未読数、未読To数、未完了タスク数を取得する
  def myStatus
    url = '/my/status'
    res = createHttpObject(url, :get)
    return JSON.parse(res.body)
  end

  # 自身のタスク一覧を取得する(最大100件)
  # assigned_by_account_id: タスク依頼者のID
  # status: タスクステータス('open' or 'done')
  def myTasks(params = {})
    url = '/my/tasks'
    res = createHttpObject(url, :get, params)
    return res.body ? JSON.parse(res.body) : []
  end

  # 自身のコンタクト一覧を取得
  def myContacts
    url = '/contacts'
    res = createHttpObject(url, :get)
    return res.body ? JSON.parse(res.body) : []
  end

  # 自身のチャットルーム一覧を取得
  def myRooms
    url = '/rooms'
    res = createHttpObject(url, :get)
    return res.body ? JSON.parse(res.body) : []
  end

  # ルームを新規作成
  def createRooms
    raise '未実装'
  end

  # ルームの情報を取得
  # room_id 取得対象のID
  def getRoom(room_id)
    url = '/rooms/' + room_id
    res = createHttpObject(url, :get)
    return res.body ? JSON.parse(res.body) : {}
  end

  # ルームの情報を更新
  # room_id:     更新対象のID
  # description: 更新後のルーム概要
  # icon_preset: 更新後のルームのアイコンセット
  # name:        更新後のルーム名
  def updateRoom(room_id, params = {})
    url = '/rooms/' + room_id
    res = createHttpObject(url, :put, params)
    return res.body ? JSON.parse(res.body) : {}
  end

  # ルームを退席する
  # room_id: 退席対象のID
  def leaveRoom(room_id)
    raise '未実装'
  end

  # ルームを削除する
  # room_id: 削除対象のID
  def deleteRoom(room_id)
    raise '未実装'
  end

  # ルームのメンバー一覧を取得
  # room_id: 対象のID
  def getRoomMembers(room_id)
    url = '/rooms/' + room_id + '/members'
    res = createHttpObject(url, :get)
    return res.body ? JSON.parse(res.body) : []
  end

  # ルームのメンバーを更新
  # room_id: 対象のID
  def updateRoomMembers(room_id, params = {})
    raise '未実装'
  end

  # ルームのメッセージ一覧を取得(最大100件)
  # room_id: 対象のroomID
  # force: 常に最新100件のみ取得する場合は1
  def getRoomMessages(room_id, params = {})
    url = '/rooms/' + room_id + '/messages'
    res = createHttpObject(url, :get)
    return res.body ? JSON.parse(res.body) : []
  end

  private
    # HTTPリクエストを送信する
    def createHttpObject(url, method, params = {})
      api_uri = URI.parse(@@API_BASE + url)
      https = Net::HTTP.new(api_uri.host, api_uri.port)
      https.use_ssl = true
      api_uri.query = URI.encode_www_form(params) if method == :get
      req = createRequestObject(method, api_uri)
      req["X-ChatWorkToken"] = @token
      req.set_form_data(params) unless method == :get
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
