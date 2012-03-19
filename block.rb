require 'group'
class Block < Group

  def bind element
    element.block=self
  end
end