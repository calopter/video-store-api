class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :movie
  validate :available, on: :checkout
  
  def available
    if self.movie.available_inventory == 0 
      errors.add(:availability, "can't check out a movie that is not in stock")
    end
  end

  def checkout 
    if self.save && self.valid?(:checkout)
      self.movie.available_inventory -= 1
      self.customer.movies_checked_out_count += 1
      self.checkout_date = Date.today
      self.due_date = (Date.today + 7)
      return true
    else
      return false
    end
  end

  def checkin
    self.movie.available_inventory += 1
    self.customer.movies_checked_out_count -= 1
  end
end
