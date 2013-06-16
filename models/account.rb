class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :email, String
  property :role, String
  property :uid, String
  property :provider, String
  property :picture, String
  
  def friendly_name
    name.nil? ? uid : name
  end
  
  def image_m
    self.picture  
  end
  
  def image_l
    provider.eql?('twitter') ? self.picture.sub("_normal", "") : 'images/profile_l.png'  
  end
  
  def update_picture(auth)
    picture = provider.eql?('twitter') ? auth['info']['image'] : 'images/profile_m.png'
    
    if(! picture.eql?(self.picture))
      self.picture = picture
      self.save
    end
  end

  def self.create_with_omniauth(auth)
    account = Account.new
    account.provider = auth["provider"]
    account.uid      = auth["uid"]
    account.name = auth["info"]["nickname"] # warn: this is for twitter
    account.save
    account
  end
  
  def change_email(email)
    raise MailFormatError if not validate_email_format(email)
    
    if not email.eql?(self.email)
      self.email = email
      raise MailChanged.new("You have changed your email to #{email}")
    end
  end
  
  def validate_email_format(email)
    (/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/).match(email) ? true : false
  end
  
  def change_name(name)
    if not name.eql?(self.name)
      self.name = name
      raise NameChanged.new("You have changed your name to #{name}")
    end
  end
end
