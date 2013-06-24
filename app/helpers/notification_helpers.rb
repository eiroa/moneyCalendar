require 'active_support/all'

MoneyCalendar::App.helpers do
  # def simple_helper_method
  # ...
  # end

  def render_hour(hour)
    hour[0..1].to_i
  end

  def render_minutes(hour)
    hour[3..4].to_i
  end

  def one_is_empty(hour, advance_notify)
   case 
    when advance_notify == "" then raise TransactionError.new("Error, Quantity of days previous is required")
    when hour == "" then raise TransactionError.new("Error, Hour of notification is required")
   end
  end
end

