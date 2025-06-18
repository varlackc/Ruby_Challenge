class RateLimiter
  def initialize(time_window, max_requests)
    # initialize your storage
    @time_window = time_window
    @max_requests = max_requests
    # declare a hash with a nested array to allow to keep track of previous timestamps
    @user_requests = Hash.new { |hash, key| hash[key] = []}
  end

  # private method used for modularity and encapsulation
  private
  def update_sliding_window(timestamp, user_id)
    # clear the sliding window
    @user_requests[user_id].reject! { |t| t <= timestamp - @time_window }
  end

  # private method used for modularity and encapsulation
  private
  def verify_number_of_elements(timestamp, user_id)
    # verify if the number of elements is less than the max_request
    if @user_requests[user_id].size < @max_requests
      # add new value to the list associated with the user_id
      @user_requests[user_id].append(timestamp)
      # if so return true
      return true
    # otherwise return false
    else
      return false
    end
  end

  # public method
  public
  def allow_request?(timestamp, user_id)
    # returns true if request is allowed, false otherwise
    # clear the sliding window
    update_sliding_window(timestamp, user_id)
    # verify number of elements
    result = verify_number_of_elements(timestamp, user_id)
    return result
  end
end