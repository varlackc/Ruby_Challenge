require 'rspec'
require_relative 'RateLimiter'

describe RateLimiter do
  let(:time_window) { 30 } # 30 seconds time window
  let(:max_requests) { 3 } # maximum 3 requests allowed
  let(:rate_limiter) { RateLimiter.new(time_window, max_requests) }
  
  # helper function to simplify the test calls
  def expect_call(time_stamp, user_id, result)
    expect(rate_limiter.allow_request?(time_stamp, user_id)).to be result
  end
  
  # helper function to simplify the data processing step  
  def test_data_call(context_data)
    # loop to test the values in the data structure
    context_data.each do |entry|
      # get the values for the data structure from each entry
      timestamp, user_id, result = entry[0], entry[1], entry[2]
      # execute the test call
      expect_call(timestamp, user_id, result)
    end
  end

  action = 'when requests are within the limit'
  response = 'allows requests within the time window'
  data = [[1700000010, 1, true],[1700000011, 2, true],[1700000020, 1, true]]
  
  context action do
    it response do
      test_data_call(data)
    end
  end
  
  action = 'when requests exceed the limit'
  response = 'blocks requests exceeding the limit within the time window'
  # Exceeds limit
  data = [[1700000010, 1, true],[1700000011, 1, true],[1700000020, 1, true], 
  [1700000035, 1, false]]
  
  context action do
    it response do
      test_data_call(data)
    end
  end

  action = 'when requests are outside the time window'
  response = 'allows requests after the time window has passed'
  # Outside time window
  data = [[1700000010, 1, true],[1700000011, 1, true],[1700000020, 1, true],
  [1700000041, 1, true]]
  
  context action do
    it response do
      test_data_call(data)
    end
  end

end