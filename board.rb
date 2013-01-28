require './element'
require './row'
require './column'
require './blocks'

class Board
  attr_reader :blanks
  def initialize
    @lines = Array.new    
    @blocks = Blocks.new
    @rows = {}
    @columns = {}
    9.times do |i|
      @columns[i+1]=Column.new
    end

    @blanks = []
  end
  
  def add_line(line)
    row_num = @rows.size+1
    @rows[row_num]=Row.new
    line_array = line.scan(/./)
    9.times do |i|
      if Element.is_valid line_array[i]
        add_element(Element.new(line_array[i], row_num, i+1), row_num, i+1 )
      else
        puts "element #{line_array[i]} is invalid"
        return false
      end
    end
    true
  end

  def resolve
    print_board("before resolve:")
    unless @rows.size == 9
      raise "invalid board"
    end

    set_variants_initial
    print_board("after initial set variants")

    @blanks = get_blank
    do_resolve 0;


    print_board("solution")
  end

  def do_resolve(index)
    return if !blanks[index]

    # generate variants for current cell
    blanks[index].generate_variants

    select_variant index

  end

  def select_variant index
    if blanks[index].has_more_variants
      # if generated, select first variant
      blanks[index].select_variant 0

      print_board(index)
      # go to next cell
      do_resolve index + 1
    else
      # go to previous cell and disregard current variant
      index = index - 1
      blanks[index].remove_variant 0
      select_variant index
    end
  end
  
  def resolve_old
    print_board("before resolve:")
    unless @rows.size == 9
      raise "invalid board"
    end

    set_variants_initial
    print_board("after initial set variants")
    @blanks = get_blank
    select_current_variants

    while has_empty?
      reset
      set_variants
      increment 0
      select_current_variants
    end

    print_board("solution")
  end



  # ------------- private methods ----------------
  private
  def increment(index)
    puts "trying to increment blank #{index+1}"
    if index == @blanks.size
      puts "incremented all possible elements"
      return
    end

    if @blanks[index].can_increment?
      @blanks[index].increment
    else
      @blanks[index].reset_variant
      index.times do |i|
        @blanks[i].reset_variant
      end
      increment index+1
    end
  end

  def sort_blanks
    #sort blanks - less variants - first
    @blanks.sort! do |element1, element2|
      if element1.variants.size == 0 && element2.variants.size != 0
        1
      else
        element1.variants.size <=> element2.variants.size
      end
    end
  end

  def select_current_variants
    @blanks.each do |element|
      if !element.select_current_variant
        print_board "breaking out of select loop - will try next increment"
        break
      end
    end
  end
  
  def has_empty?
    each do |element|
      if element.blank?
        return true
      end
    end 
    false
  end
  
  def get_blank
    blank = []
    each do |element|
      unless element.value_provided?
        blank.push element
      end
    end 
    blank
  end
  
  def set_variants_initial
    each do |element|
      element.set_variants_initial
    end 
  end

  def set_variants
    each do |element|
      element.set_variants
    end
  end

  def reset
    @blanks.each do |element|
      element.reset
    end
  end
  
  
  def print_board(comment)
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
    #puts "adding element #{element} #{row_num} #{col_num}"
    @rows[row_num].add element
    @columns[col_num].add element
    @blocks.block(row_num, col_num).add element
  end

  
end