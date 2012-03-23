require './group'
class Row < Group

  def bind element
    element.row=self
  end
  
end