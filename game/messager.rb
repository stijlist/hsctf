class Messager
  def initialize
    @client = Zulip::Client.new do |config|
      config.email_address = ENV.fetch('CTF_ZULIP_BOT_EMAIL')
      config.api_key = ENV.fetch('CTF_ZULIP_API_KEY')
    end
  end

  def listen(callback)
    @client.stream_messages do |message|
      callback.call(message)
    end
  end

  # takes a hash of player attributes and sends them a private message
  def send_message(player, message)
    @client.send_private_message(message, player['email'])
  end

  def broadcast_message(stream, subject, message)
    @client.send_message(subject, message, stream)
  end
end
