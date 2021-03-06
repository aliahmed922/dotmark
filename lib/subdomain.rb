class Subdomain
  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      account = $redis.get("routes_#{request.subdomain}")
      
      if account.nil?
        account = Account.find_by(subdomain: request.subdomain).to_json
        $redis.set("routes_#{request.subdomain}", account)
      end
      account = JSON.load(account)

      if account
        # if account["resource_type"] == "Student" or account["resource_type"] == "Teacher"
        return true if account["resource_type"] == "Student" or account["resource_type"] == "Teacher" # -> if account is not found, return false (IE no route)
      end
    end
  end
end