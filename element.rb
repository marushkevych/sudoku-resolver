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

      # binding to cell's groups (set by groups)
      @row=nil
      @column=nil
      @block=nil
    else 
      raise "invalid character #{ch}"
    end
  end
  
  attr_accessor :row, :column, :block, :variants, :variant_index
  attr_reader :col_index

  def set_variants_initial
    return if value_provided?
    (1..9).each do |i|
      @variants[i-1]=i
    end
    remove_extra_variants
    #puts "Set variants in (#{@row_index}, #{@col_index}): #{@variants.inspect}"
    if @variants.size == 1
      @init_value = @variants[0]
      #puts "Selected init_value in (#{@row_index}, #{@col_index}): #{@variants[0]}"
    end
  end

  def generate_variants
    if value_provided?
      raise "can not generate variants - fixed cell"
    end

    (1..9).each do |i|
      @variants[i-1]=i
    end

    remove_extra_variants

    if @variants.size > 0
      true
    else
      @selected = nil
      false
    end
  end

  def remove_variant(index)
    @variants.delete_at index
    @selected = nil
  end

  def has_more_variants
    @variants.size > 0
  end

  def select_variant index
    @selected = @variants[index]
  end

  # deprecated
  def set_variants
    return if value_provided?

    (1..9).each do |i|
      @variants[i-1]=i
    end
    remove_extra_variants
    #puts "Set variants in (#{@row_index}, #{@col_index}): #{@variants.inspect}"

    if @variants.size == 1
      @selected = @variants[0]
      #puts "Selected variant in (#{@row_index}, #{@col_index}): #{@variants[0]}"

    end
  end

  def can_increment?
    @variant_index < (@variants.size - 1)
  end


  def increment
    @variant_index += 1
    puts "Incremented (#{@row_index}, #{@col_index}) to #{@variant_index}"
  end
  
  def reset_variant
    #puts "resetting variant index in (#{@row_index}, #{@col_index})"
    @variant_index=0
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

  def value_provided?
    @init_value != nil
  end

  protected
  def value
    if @init_value
      @init_value
    elsif @selected
      @selected
    else
      " "
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
