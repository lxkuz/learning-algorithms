#!/usr/bin/env ruby
# by Andronik Ordian

def fib_sum_last_digit(n)
  return 0 if n == 0
  
  return 1 if n == 1
  
  return 2 if n == 2
  res = 0,1
  i = (n + 2) % 60
  while i > 1
    next_step = res[1] + res[0]
    res[0] = res[1]
    res[1] = next_step % 10
    i -= 1
  end
  return 9 if res.last == 0

  res.last - 1
end

if __FILE__ == $0
  n = gets.to_i
  puts "#{fib_sum_last_digit(n)}"
end
