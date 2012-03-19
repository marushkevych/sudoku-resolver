require 'element'
require 'row'
require 'column'
require 'blocks'

class Board
  def initialize
    @lines = Array.new    
    @blocks = Blocks.new
    @rows = {}
    @columns = {}
    @incremented = 0
    9.times do |i|
      @columns[i+1]=Column.new
    end
end
  
  def add_line line
    row_num = @rows.size+1
    @rows[row_num]=Row.new
    lineArray = line.scan(/./)
    9.times do |i|
      if Element.is_valid lineArray[i]
        add_element(Element.new(lineArray[i], row_num, i+1), row_num, i+1 )
      else
        puts "element #{lineArray[i]} is invalid"
        return false
      end
    end
    true
  end
  
  def resolve
    print_board("before resolve:")
    if @rows.size != 9 
      raise "invalid board"
    end
    
    set_variants
    @blank = get_blank 
    self.select
    
    while (has_empty?)
      @blank.each do |element|
        element.reset
      end
      
      set_variants
      
      self.increment 0
      self.select
      
      print_board("solution")
    
    end
  end
  
  def select
    @blank.each do |element|
      if (!element.select)
        #puts "breaking out of select loop - will try next increment"
        break
      end
    end 
  end
  
  
  def increment index
    if (index == @blank.size)
      puts "incremented all possible elements"
      return
    end
  
    if @blank[index].increment
      return
    else 
      @blank[index].reset_variant
      index.times do |i|
        @blank[i].reset_variant
      end
      if ((index+1) > @incremented)
        @incremented = index+1 
        puts "INCREMENTING #{index+1}"
        
      end
      increment index+1
    end
    
  end
  
  # ------------- private methods ----------------
  private
  
  def has_empty?
    each do |element|
      if (element.value == " ")
        return true
      end
    end 
    false
  end
  
  def get_blank
    blank = []
    each do |element|
      if (element.blank?)
        blank.push element
      end
    end 
    return blank
  end
  
  def set_variants
    each do |element|
      element.set_variants
    end 
    print_board("after set_variants")
  end
  
  def reset
    each do |element|
      element.reset
    end
  end
  
  
  def print_board (comment)
    puts comment
    puts '-------------------------'
    9.times do |i|
      row_index = i+1
      print '|'
      @rows[row_index].each do |element|
        print ' ' + element.to_s
        if element.col_index % 3 == 0
          print ' |'
        end
      end
      puts
      if (row_index)%3 == 0 
        puts '-------------------------' 
      end
    end   
     
  end
  
  def each 
    9.times do |i|
      @rows[i+1].each do |element|
        yield element
      end
    end 
  end
  
  # linck each element to related Row Column and Block objects
  def add_element (element, row_num, col_num)
    puts "adding element #{element} #{row_num} #{col_num}"
    @rows[row_num].add element
    @columns[col_num].add element
    @blocks.block(row_num, col_num).add element
  end

  
end