# http://www.rubytutorial.io/actioncable-devise-authentication/
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["signed_#{scope}_id"] = user.id
  auth.cookies["#{scope}_id"] = user.id
end

Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["signed_#{scope}_id"] = nil
end
