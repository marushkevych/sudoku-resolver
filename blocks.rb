require './block'
class Blocks
  def initialize
    @blocks = {}
    
    9.times do |i|
      @blocks[i+1]=Block.new
    end
  end
  
  def block(row_num, col_num)
    
    row_index = derive_block_index row_num
    col_index = derive_block_index col_num

    index = if row_index == 1
      col_index
    else
      (row_index - 1)*3 + col_index
    end
    
    @blocks[index]
    
  end
  private
  def derive_block_index (num)
    case num
      when (1..3); 1
      when (4..6); 2
      when (7..9); 3
    end
  end
  
end