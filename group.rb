# represents group of cells that has to have unique elements
# (row, column, block)
class Group
  def initialize
    @elements = Array.new
  end
  
  def add element
    if @elements.size == 9
      raise "Can not add more then 9 elements"
    end
    @elements.push element
    bind element
  end
  
  def limit_variants
    @elements.each do |element|
      element.remove_extra_variants
    end
  end
  
  def each 
    @elements.each do |element|
      yield(element)
    end
  end
  
  def to_s
    @elements.inspect
  end
  
  protected
  def bind element
    raise "unsupported method"
  end
  
end