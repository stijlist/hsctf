class CTF
  def initialize
    @messager = Messager.new
    @game = Game.new.add_root_challenge('alpha.yaml')
    @quartermaster = Quartermaster.new(@game, @messager)
    @messager.listen do |message|
      if message['type'] == 'private' # TODO: probably not the correct check for pms
        @quartermaster.receive_pm(message)
      end
    end
  end
end
