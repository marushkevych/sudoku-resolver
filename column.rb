require 'group'
class Column < Group

  def bind element
    element.column=self
  end
end