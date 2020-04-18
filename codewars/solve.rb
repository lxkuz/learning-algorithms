require 'byebug'
require 'matrix'
class LxkuzMatrix
  def initialize(data, column_count_value = data[0].size)
    @data = Marshal.load(Marshal.dump(data))
    @column_count = column_count_value
    @row_count = data.size
    @pivots = build_pivots
  end

  def to_a
    @data
  end

  def row(n)
    data[n]
  end

  def solve(mtrx)
    nx = mtrx.column_count
    m = pivots.map{|row| mtrx.row(row).to_a}
    
    column_count.times do |k|
      (k+1).upto(column_count-1) do |i|
        nx.times do |j|
          m[i][j] -= m[k][j]*lu[i][k]
        end
      end
    end

    (column_count-1).downto(0) do |k|
      nx.times do |j|
        m[k][j] = m[k][j].quo(lu[k][k])
      end
      k.times do |i|
        nx.times do |j|
          m[i][j] -= m[k][j]*lu[i][k]
        end
      end
    end
    LxkuzMatrix.new m, nx
  end
  
  attr_reader :column_count, :row_count

  private

  attr_reader :data,  :pivots, :lu

  def build_pivots
    @lu = Marshal.load(Marshal.dump(data))
    result = Array.new(row_count)
    row_count.times do |i|
      result[i] = i
    end
    pivot_sign = 1
    lu_col_j = Array.new(row_count)
  
    # Outer loop.
  
    column_count.times do |j|
  
      # Make a copy of the j-th column to localize references.
  
      row_count.times do |i|
        lu_col_j[i] = @lu[i][j]
      end
  
      # Apply previous transformations.
  
      row_count.times do |i|
        lu_row_i = @lu[i]
  
        # Most of the time is spent in the following dot product.
  
        kmax = [i, j].min
        s = 0
        kmax.times do |k|
          s += lu_row_i[k]*lu_col_j[k]
        end
  
        lu_row_i[j] = lu_col_j[i] -= s
      end
  
      # Find pivot and exchange if necessary.
  
      p = j
      (j+1).upto(row_count-1) do |i|
        if (lu_col_j[i].abs > lu_col_j[p].abs)
          p = i
        end
      end
      if (p != j)
        column_count.times do |k|
          t = @lu[p][k]; @lu[p][k] = @lu[j][k]; @lu[j][k] = t
        end
        k = result[p]; result[p] = result[j]; result[j] = k
        pivot_sign = -pivot_sign
      end

      # Compute multipliers.

      if (j < row_count && @lu[j][j] != 0)
        (j+1).upto(row_count-1) do |i|
          @lu[i][j] = @lu[i][j].quo(@lu[j][j])
        end
      end
    end
    result
  end
end

def simplify(examples, formula)
  variables = detect_variables(examples)
  argument_name = variables[0] 
  # => :a
  default_row = variables.map{|v| [v, nil]}.to_h 
  # => {b: nil, c: nil, d: nil}
  matrix = []

  examples.each do |example|
    row = parse_example(example, default_row)
    matrix = matrix.push(row)
  end
  results_vector = solve(matrix)
  formula_vector = parse_formula(formula, default_row)
  result(results_vector, formula_vector, argument_name)
end

def parse_example(example, default_row)
  result = []
  line = example.delete(' ')
  left_side, right_side = line.split('=')
  default_row.each do |key, _nil_value|
    koef = get_argument_koef(left_side, key) -
      get_argument_koef(right_side, key)
    result.push(koef)
  end
  result[1..-1] + [-result[0]]
end

def parse_formula(formula, default_row)
  result = []
  line = formula.delete(' ')
  default_row.each do |key, _nil_value|
    koef = get_argument_koef(line, key)
    result.push(koef)
  end
  result
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

def detect_variables(examples)
  examples.map do |example|
    example.scan(/([a-z])/).flatten
  end.flatten.uniq.map &:to_sym
end

def result(results_vector, formula_vector, argument_name)
  result = 0
  results = [1, results_vector].flatten
  formula_vector.each_with_index do |attr_koef, index|
    result += results[index] * attr_koef
  end
  "#{result.to_i}#{argument_name}"
end

def solve(matrix)
  original_matrix = matrix.to_a
  left_matrix  = []
  right_vector = []
  original_matrix.each do |line|
    right_vector << [ line.last ]
    left_matrix << line[0..-2]
  end
  decomposed_matrix = LxkuzMatrix.new(left_matrix)
  decomposed_matrix.solve(LxkuzMatrix.new(right_vector)).to_a
end

def test
  # test_original_matrix
  # test_lxkuz_matrix
  # test_main
  test_brackets_single
  puts 'ALL GOOD'
end

def test_main
  examples  = [["a + a = b", "b - d = c", "a + b = d"], ["a + 3g = k", "-70a = g"], ["-j -j -j + j = b"] ]
  formulas  = [ "c + a + b",                             "-k + a",                   "-j - b"]
  expected = [ "2a",                                    "210a",                     "1j"]

  expected.zip(examples, formulas).each do |expected,examples,formula|
    act = simplify(examples,formula)
    raise 'Test Failed' unless expected == act
  end
end

def test_lxkuz_matrix
  puts "Examples: LXKUZ MATRIX CHECK"
  matrix = LxkuzMatrix.new([[-1.0, 0.0, 0.0], [1.0, -1.0, -1.0], [1.0, -1.0, 0.0]])
  vector = LxkuzMatrix.new([-2.0, 0.0, -1.0].map{|a| [a] })
  result = [2.0, 3.0, -1.0]
  solve_result = matrix.solve(vector).to_a.flatten
  unless  solve_result == result
    puts "Expected: #{result.inspect}"
    puts "Got: #{solve_result.inspect}"
    raise 'Test Failed' 
  end
end

def test_original_matrix
  puts "Examples: ORIGINAL MATRIX CHECK"
  matrix = Matrix::LUPDecomposition.new(
    Matrix[[-1.0, 0.0, 0.0], [1.0, -1.0, -1.0], [1.0, -1.0, 0.0]]
  )
  vector = Matrix[[-2.0], [0.0], [-1.0]]
  result = [2.0, 3.0, -1.0]
  solve_result = matrix.solve(vector).to_a.flatten
  unless  solve_result == result
    puts "Expected: #{result.inspect}"
    puts "Got: #{solve_result.inspect}"
    raise 'Test Failed' 
  end
end


def test_brackets_single
  examples = 	['(-3f + q) + r = l', '4f + q = r','-10f = q']
  formula =	'20l + 20(q - 200f)'
  expected ='-4580f'
  act = simplify(examples,formula)
  unless  act == expected
    puts "Expected: #{expected.inspect}"
    puts "Got: #{act.inspect}"
    raise 'Test Failed' 
  end
end

def test_brackets_nested
  examples = 	['-9w = A', '14w - 3A = n', '-7w + 18A + 9n = g']
  formula =	'2(2g - 3(-1n + 2g) + 1g) - 1n - 2g'
  expected ='481w'
  act = simplify(examples,formula)
  unless  act == expected
    puts "Expected: #{expected.inspect}"
    puts "Got: #{act.inspect}"
    raise 'Test Failed' 
  end
end

test