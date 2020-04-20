  require 'matrix'


  def simplify(examples, formula)
    variables = detect_variables(examples)
    argument_name = variables[0] 
    # => :a
    default_row = variables.map{|v| [v, nil]}.to_h 
    # => {b: nil, c: nil, d: nil}
    matrix = Matrix.empty(0,default_row.keys)

    examples.each do |example|
      row = parse_example(example, default_row)
      matrix = matrix.vstack(row)
    end
    results_vector = solve(matrix)
    formula_vector = parse_example(formula, default_row)
    result(imatrix, formula_vector, argument_name)
  end

  def parse_example(example, default_row)
    result = []
    line = example.delete(' ')
    left_side, right_side = line.split('=')
    while left_side.include?('(')
      left_side = open_brackets(left_side)
    end
    while right_side.include?('(')
      right_side = open_brackets(right_side)
    end
    default_row.each do |key, _nil_value|
      koef = get_argument_koef(left_side, key) -
        get_argument_koef(right_side, key)
      result.push(koef)
    end
    row = result[1..-1] + [-result[0]]
    Matrix[row]
  end

  def get_argument_koef(line, name)
    regexp = %r{(\A#{name.to_s}|[-+]\d*#{name.to_s})}
    matches = line.scan(regexp).flatten
    matches.map{|s| s.delete(name.to_s)}.map do |value|
      if value == "" or value == "+"
        1
      elsif value == '-'
        -1
      else
        value.to_i
      end
    end.sum
  end

  def open_brackets(line)
    regexp = %r{((\A|[-+]?\d*|)[(]([^()]+)[)])} 
    line.gsub!(regexp) do |exp|
      koef, bracket_line = exp.split('(') 
      if koef == "" or koef == "+"
        koef = 1
      elsif koef == '-'
        koef = -1
      else
        koef =koef.to_i
      end
      bracket_line.gsub!(')', '')
      open_bracket(koef, bracket_line)
    end
    return line
  end

  def open_bracket(koef, str)
    regexp = %r{(\A-?\d*|[-+]\d*)}
    str.gsub(regexp) do |el|
      if el == "" or el == "+"
        if koef > 0
          "+#{koef}"
        else
          koef
        end
      elsif el == '-'
        if koef < 0
          "+#{-koef}"
        else
          -koef
        end
      else
        if el.to_i*koef > 0
          "+#{el.to_i*koef}"
        else
          el.to_i*koef
        end
      end
    end
  end

  def detect_variables(examples)
    examples.map do |example|
      example.scan(/([a-z])/).flatten
    end.flatten.uniq.map &:to_sym
  end

  def result(results_vector, formula_vector, argument_name)
    result = 0
    formula_vector.each_with_index do |attr_koef, index|
      result += results_vector[index] * attr_koef
    end
    "#{result}#{argument_name}"
  end

  def solve(matrix)
    original_matrix = matrix.to_a
    normalize_matrix!(original_matrix)
    left_matrix  = []
    right_vector = []
    original_matrix.each do |line|
      right_vector << line.last
      left_matrix << line[0..-2]
    end
    gaussianElimination(matrix, vector)
    backSubstitution(matrix, vector)
    vector
  end

  def gaussianElimination(matrix, vector)
    0.upto(matrix.length - 2) do |pivotIdx|
      maxRelVal = 0
      maxIdx = pivotIdx
      (pivotIdx).upto(matrix.length - 1) do |row|
        relVal = matrix[row][pivotIdx] / matrix[row].map{ |x| x.abs }.max
        if relVal >= maxRelVal
          maxRelVal = relVal
          maxIdx = row
        end
      end

      matrix[pivotIdx], matrix[maxIdx] = matrix[maxIdx], matrix[pivotIdx]
      vector[pivotIdx], vector[maxIdx] = vector[maxIdx], vector[pivotIdx]

      pivot = matrix[pivotIdx][pivotIdx]
      (pivotIdx+1).upto(matrix.length - 1) do |row|
        factor = matrix[row][pivotIdx]/pivot
        matrix[row][pivotIdx] = 0.0
        (pivotIdx+1).upto(matrix[row].length - 1) do |col|
            matrix[row][col] -= factor*matrix[pivotIdx][col]
        end
        vector[row] -= factor*vector[pivotIdx]
      end
    end
    return [matrix,vector]
  end

  def backSubstitution(matrix, vector)
    (matrix.length - 1).downto( 0 ) do |row|
      tail = vector[row]
      (row+1).upto(matrix.length - 1) do |col|
        tail -= matrix[row][col] * vector[col]
        matrix[row][col] = 0.0
      end
      vector[row] = tail / matrix[row][row]
      matrix[row][row] = 1.0
    end
  end

  def div_items!(matrix, item_numbers, divider)
    item_numbers.each do |(x, y)|
      matrix[x][y] /= divider 
    end
  end

  def swap_lines!(matrix, x, y)
    line_x = matrix[x].dup
    line_y = matrix[y].dup
    matrix[x] = line_y
    matrix[y] = line_x
  end

  def normalize_matrix!(matrix)
    size = matrix.size
    success_count = 0
    matrix.each_with_index do |line, index|
      if line[index] == 0
        rand_index = rand(size)
        swap_lines!(matrix, index, rand_index)
      else
        success_count += 1
      end
    end
    normalize_matrix!(matrix) if success_count < size
  end