module MoneyCalendar
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    enable :sessions

    ##############################
    ##        OmniAuth
    ##############################
    configure  :development,:travis, :test do
      use OmniAuth::Builder do
        provider :developer
      end
      set :login_page, "/login"
      ENV['APP_URL'] = 'http://127.0.0.1:3000/'
    end

    configure  :staging, :production do
      use OmniAuth::Builder do
        provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_SECRET_KEY']
      end
      set :login_page, "/auth/twitter"
    set :delivery_method, :smtp => {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :user_name            => ENV['GMAIL_ADDRESS'],
        :password             => ENV['GMAIL_PASSWORD'],
        :authentication       => :plain,
        :enable_starttls_auto => true
    }
    end

    get :login do
      render '/home/login'
    end

    get :auth, :map => '/auth/:provider/callback' do
      auth    = request.env["omniauth.auth"]
      account = Account.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
      Account.create_with_omniauth(auth)
      account.update_picture(auth)
      set_current_account(account)
      redirect "/coming_expirations"
    end

    # Access control
    access_control.roles_for :any do |role|
      role.protect "/coming_expirations"
      role.protect "/save_payment"
      role.protect "/new_transaction"
      role.protect "/profile"
    end

    ##############################
    ##            APP
    ##############################
    get '/' do
      render 'home/index'

    end

    get :coming_expirations do
      @expirations = Transaction.get_last_sorted(10, current_account.id)
      render 'coming_expirations'
    end

    get '/save' do
      @is_payment = params[:is_payment]
      @periodicity =  params[:periodicity]

      begin
        @transaction = Transaction.create(current_account, @is_payment, @periodicity,
          params[:name], params[:amount], params[:date],
          params[:description])
        
        @notify = params[:notify]
        if(@notify)
          one_is_empty(params[:time_notify], params[:advance_notify])
          @advance_notify = params[:advance_notify]
          new_notification = Notification.add_new(@transaction, @advance_notify, params[:time_notify], current_account)
          @transaction.notification = new_notification
        end
 
        @transaction.save
        render 'save'

      rescue TransactionError, TransactionRepeated => e
        @errorMessage = e.message
        render 'new_transaction'
      end
    end

  
    
    get '/new_transaction' do
      @is_payment = params[:is_payment]
      render 'new_transaction'
    end

   
    
    get :stats do
      is_payment = params[:type].eql?('0') ? false : true
      @transaction_type = is_payment ? 'payments' : 'incomes'
      @from_date = params[:from_date]
      @to_date = params[:to_date]

      @stats = TransactionDone.from_to(@from_date, @to_date, is_payment)
      @total = @stats.sum(:amount)
      @dates, @data = Stats.dates_and_data_from_to(@stats, @from_date, @to_date)
      render 'stats'
    end

    get :logout do
      set_current_account(nil)
      redirect '/'
    end

    get :pay do
      @payment = Transaction.first( :account_id => current_account.id, :is_payment => true, :name => params[:payment_name])
      render 'pay'
    end
    
    get :save_payment do

      begin
        @payment = Transaction.new_increased_date(current_account.id, true, params[:name])
        @payment.save
        render 'save_payment'
   
      rescue TransactionError, TransactionRepeated => e
        @Message = e.message
        render 'pay'
      end
    end  

    get :profile do
      render 'profile'
    end

    get :save_profile do
      @current_account = current_account
      @message = ""
      
      begin
        @current_account.change_email(params[:email])
      rescue MailFormatError, MailChanged => e
        @message << "#{e.message}"
      end
      
      begin
        @current_account.change_name(params[:name])
      rescue NameChanged => e
        @message << "\n #{e.message}"
      end
      
      @current_account.save
      
      render 'profile'
    end

  get :sendmail do
    render 'email'
  end
  post :email do
      email(:from => "fmmainere@gmail.com", :to => "fmmainere@gmail.com", :subject => "Welcome!", :body=>"Body")
  end

    ##
    # Caching support
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
    # set :cache, Padrino::Cache::Store::Memory.new(50)
    # set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_app/locales)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    error 404 do
      'Service not Found! :('
    end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #
  end
end
