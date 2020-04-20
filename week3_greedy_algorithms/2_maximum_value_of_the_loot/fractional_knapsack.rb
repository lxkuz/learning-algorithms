#!/usr/bin/env ruby
# by Andronik Ordian

def get_optimal_value(capacity, weights, values)
  value = 0.0
  sorted_items = values.zip(weights).sort_by{|v, w| - v.to_f / w}
  for i in 0..weights.length
    return value if capacity == 0
    if sorted_items[i][1] > capacity
      a = capacity
    else
      a = sorted_items[i][1]
    end
    value += a * sorted_items[i][0].to_f / sorted_items[i][1]
    capacity -= a
  end
  value
end

def test
  raise "ERROR: #{get_optimal_value(7, [4,3,2], [20,18,14])} != 42" if get_optimal_value(7, [4,3,2], [20,18,14]) != 42.0
  reise "Error" if input_wrapper([1, 1000, 500, 30]) != 500.0
end

# def input_wrapper(data)
#   n, capacity = data[0,2]
#   values = data.values_at(*(2..2*n).step(2))
#   weights = data.values_at(*(3..2*n+1).step(2))
#   get_optimal_value(capacity, weights, values)
# end

if __FILE__ == $0
  data = STDIN.read.split().map(&:to_i)
  # puts data
  n, capacity = data[0,2]
  values = data.values_at(*(2..2*n).step(2))
  weights = data.values_at(*(3..2*n+1).step(2))
  answer = get_optimal_value(capacity, weights, values)
  puts "#{'%.4f' % answer}"
end