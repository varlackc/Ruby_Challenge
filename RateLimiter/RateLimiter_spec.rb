require 'rspec'
require_relative 'RateLimiter'

describe RateLimiter do
  let(:time_window) { 30 } # 30 seconds time window
  let(:max_requests) { 3 } # maximum 3 requests allowed
  let(:rate_limiter) { RateLimiter.new(time_window, max_requests) }

  context 'when requests are within the limit' do
    it 'allows requests within the time window' do
      expect(rate_limiter.allow_request?(1700000010, 1)).to be true
      expect(rate_limiter.allow_request?(1700000011, 2)).to be true
      expect(rate_limiter.allow_request?(1700000020, 1)).to be true
    end
  end

  context 'when requests exceed the limit' do
    it 'blocks requests exceeding the limit within the time window' do
      expect(rate_limiter.allow_request?(1700000010, 1)).to be true
      expect(rate_limiter.allow_request?(1700000011, 1)).to be true
      expect(rate_limiter.allow_request?(1700000020, 1)).to be true
      expect(rate_limiter.allow_request?(1700000035, 1)).to be false # Exceeds limit
    end
  end

  context 'when requests are outside the time window' do
    it 'allows requests after the time window has passed' do
      expect(rate_limiter.allow_request?(1700000010, 1)).to be true
      expect(rate_limiter.allow_request?(1700000011, 1)).to be true
      expect(rate_limiter.allow_request?(1700000020, 1)).to be true
      expect(rate_limiter.allow_request?(1700000041, 1)).to be true # Outside time window
    end
  end

end