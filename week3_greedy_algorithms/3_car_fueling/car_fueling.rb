def compute_min_refills(distance, tank, stops)
  stops = [0, *stops, distance]
  refills = 0
  current_refill = 0
  n = stops.length - 2
  while current_refill <= n 
    last_refill = current_refill
    while current_refill <= n and stops[current_refill + 1] - stops[last_refill] <= tank
      current_refill += 1
    end
    if last_refill == current_refill
      return -1
    end
    if current_refill <= n
      refills += 1
    end
  end
  refills
end

def test
  raise "ERROR" if compute_min_refills(3, 1, [1, 2, 3]) != 2
  raise "ERROR!" if compute_min_refills(500, 200, [100, 200, 300, 400]) != 2
  puts 'All good'
end

if __FILE__ == $0
  d = gets.to_i
  m = gets.to_i
  n = gets.to_i
  stops = gets.split().map(&:to_i)
  puts "#{compute_min_refills(d, m, stops)}"
end
