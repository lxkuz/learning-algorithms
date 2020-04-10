#!/usr/bin/env ruby
# by Andronik Ordian
def fib_huge(n, m)
  return 0 if m == 1
  return 0 if m == 2 && n % 3 == 0
  return 1 if m == 2
  return 0 if m == 3 && n % 4 == 0
  return 0 if m == 4 && n % 6 == 0
  return 0 if m == 5 && n % 5 == 0
  return 0 if m == 6 && n % 12 == 0
  return 0 if m == 7 && n % 8 == 0
  return n % m if n <= 1
  
  res = 0,1
  i = n
  while i > 1
    next_step = (res[1] + res[0]) % m
    res[0] = res[1]
    res[1] = next_step
    i -= 1
  end
  res.last
end

if __FILE__ == $0
  a, b = gets.split().map(&:to_i)
  puts "#{fib_huge(a, b)}"
end