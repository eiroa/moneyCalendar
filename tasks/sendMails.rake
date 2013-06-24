namespace :mails do
  desc "Sends mails to users"
  task :sendmails => :environment do
      all_notifications = Notification.all(:transaction => Transaction.all)
      today = DateTime.now
      notifications = Array.new
      all_notifications.each do |n|
         if same_day_and_time?(n.notify_date, today)
            n.send_mail
         end
      end
   end
end

def same_day_and_time?(date, today)
   date.year == today.year && date.month == today.month && date.day == today.day && date.hour == today.hour && date.minute == today.minute
end
