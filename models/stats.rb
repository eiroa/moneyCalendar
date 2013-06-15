class Stats
  # stats: [TransactionDone]
  # from_date: string
  # to_date: string
  # returns: [dates], [data]
  def self.dates_and_data_from_to(stats, from_date, to_date)
    date = Date.parse(from_date)
    laterdate = Date.parse(to_date)
    
    dates = []
    data = []
    
    (date.year..laterdate.year).each do |y|
       mo_start = (date.year == y) ? date.month : 1
       mo_end = (laterdate.year == y) ? laterdate.month : 12
    
       (mo_start..mo_end).each do |m|  
           dates << ("#{Date::MONTHNAMES[m]}/#{y}")
           
           amount = 0
           stats.each do |s|
             amount += s.amount if (s.pay_date.year == y) && (s.pay_date.month == m)
           end
           
           data << amount
       end
    end

    return dates, data
  end
end