#!/usr/bin/env ruby
# by Andronik Ordian

def max_dot_product(a, b)
  sorted_a = a.sort
  sorted_b = b.sort
  sorted_a.zip(sorted_b).map{|(item_a, item_b)| item_a * item_b }.sum
end

if __FILE__ == $0
  _n = gets.to_i
  a = gets.split().map(&:to_i)
  b = gets.split().map(&:to_i)
  puts "#{max_dot_product(a, b)}"
end

# def test
#   raise 'ERROR 1' if max_dot_product([1, 3, -5], [ -2, 4, 1]) != 23
#   raise 'ERROR 2' if max_dot_product([1, 2, 3], [ 5, 7, 6]) != (21 + 12 + 5)
#   puts('ALL GOOD')
# end
  
# test