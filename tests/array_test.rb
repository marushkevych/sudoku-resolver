require '../element'

    element1 = Element.new(" ", 1, 1)
    element1.variants = [1]

    element2 = Element.new(" ", 1, 2)
    element2.variants = [1,2,3]

    element3 = Element.new(" ", 1, 3)
    element3.variants = [1,2]

    elements = [];
    elements.push element1;
    elements.push element2;
    elements.push element3;

    puts elements[0].col_index
    puts elements[1].col_index
    puts elements[2].col_index

    elements.sort!(){|a,b| a.variants.length <=> b.variants.length}

    puts elements[0].col_index
    puts elements[1].col_index
    puts elements[2].col_index