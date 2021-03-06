class AccountMailer < Devise::Mailer   
	helper :application # gives access to all helpers defined within `application_helper`.
	# include DecryptedHash
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  # default template_path: 'mailer' # to make sure that your mailer uses the devise views
  layout 'mailer'
  default template_path: 'devise/mailer'
	default from: 'notifications@dotmark.com'

  def confirmation_instructions(record, token, opts={})
  	@full_name = record.full_name
  	@subdomain = record.account.subdomain
	  headers["Custom-header"] = "Bar"
	  opts[:from] = 'donotreply@dotmark.com'
	  opts[:reply_to] = 'donotreply@dotmark.com'
	  super
	end

	def account_access(user)
		@resource = user
		@full_name = @resource.full_name
		@login_email = "#{@resource.email}"
		@login_username = "#{@resource.username}"
		@login_password = "#{StringEncryptor.new.decrypt_hash(@resource.temp_password)}"
		
		if @resource.class == Student
			@login_url = students_login_after_confirmation_url(resource: @resource.username, subdomain: "#{@resource.account.subdomain}")
		else
			@login_url = teachers_login_after_confirmation_url(resource: @resource.username, subdomain: "#{@resource.account.subdomain}")
		end
    mail(to: @resource.email, subject: 'Account Credentials')
	end
end
