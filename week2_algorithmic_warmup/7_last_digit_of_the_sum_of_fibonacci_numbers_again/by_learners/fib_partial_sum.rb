#!/usr/bin/env ruby
# by Andronik Ordian

def fib_partial_sum(n, m)
  res1 = 0,1
  res2 = 0,1
  i = (n + 2) % 60
  while i > 2
    next_step = res1[1] + res1[0]
    res1[0] = res1[1]
    res1[1] = next_step % 10
    i -= 1
  end

  k = (m + 2) % 60
  while k > 1
    next_step = res2[1] + res2[0]
    res2[0] = res2[1]
    res2[1] = next_step % 10
    k -= 1
  end

  return res2.last - 1 if res1.last - 1 >= 0 && n == 1
  return 9 if res2.last == 0 && m == 1
  return res2.last - res1.last if res2.last - res1.last >= 0

  10 + res2.last - res1.last
end

if __FILE__ == $0
  m, n = gets.split().map(&:to_i)
  puts "#{fib_partial_sum(m, n)}"
end
