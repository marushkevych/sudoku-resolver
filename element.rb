class Element
  def self.is_valid (ch)
    ch == " " || (1..9).member?(ch.to_i)
  end

  def initialize (ch, row_index, col_index)
    if Element.is_valid ch
      @init_value=ch.to_i if ch != " "
      @variant_index=0
      @row_index=row_index
      @col_index=col_index
      @variants=[]
    else 
      raise "invalid character #{ch}"
    end
  end
  
  attr_accessor :row, :column, :block
  attr_reader :col_index

  def set_variants
    return if set?

    (1..9).each do |i|
      @variants[i-1]=i
    end
    self.remove_extra_variants

    @variants.compact!

    if @variants.size == 1
      @init_value = @variants[0]
    end

    #puts "Set variants in (#{@row_index}, #{@col_index}): #{@variants.inspect}"
  end
  
  def increment_old
    #puts "incrementing #{@variant_index} in element (#{@row_index}, #{@col_index}), variants: #{@variants.inspect}"
    @variant_index=@variant_index+1
    return false if @variant_index == 9
    
    if @variants.has_key? @variant_index
      puts "incremented to #{@variant_index}, returning true"
       true
    else
      puts "no variant with index #{@variant_index}, continue increment"
      self.increment
    end
  end
  
  def increment
    @variant_index = @variant_index + 1
    if @variant_index == @variants.size
      return false
    end
    true
  end
  
  def reset_variant
    #puts "resetting variant index in (#{@row_index}, #{@col_index})"
    @variant_index=0
  end
  
  
  def select
    if set?
      return true
    end   
    
    #puts "trying to select variant #{@variant_index} in element (#{@row_index}, #{@col_index}), variants: #{@variants.inspect}"
    if @variants[@variant_index] != nil
      @selected = @variants[@variant_index]
      row.limit_variants
      column.limit_variants
      block.limit_variants
       true
    else
       false
    end 
  end
  
  
  
  def set?
    @init_value != nil
  end
  
  
  def value
    if @init_value
      @init_value
    elsif @selected
      @selected
    else
      " "
    end
  end
  
  def blank?
    case value
      when " "; true
      else false
    end
  end

  def reset
    #puts "resetting element (#{@row_index}, #{@col_index})"

    @variants.clear
    @selected = nil
    #set_variants
  end
  
  
  def to_s
    value.to_s
  end
  
  def remove_extra_variants
      strip_variants(row)
      strip_variants(column)
      strip_variants(block)
    end

  def limit_variants
    if blank?
      strip_variants(row)
      strip_variants(column)
      strip_variants(block)
    end
  end

  private
  def strip_variants (group)
      group.each do |element|
        @variants.delete_if do |value|
          element.value==value
        end
      end
  end  
end