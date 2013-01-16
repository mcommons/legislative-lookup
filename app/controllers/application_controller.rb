# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store

  protect_from_forgery # :secret => 'a721e67c89b39d5e55d6a42e3b5c1fa0' # liger1 but not liger2 had this line commented out
  skip_before_filter :verify_authenticity_token # liger2 but not liger1 had this line added
  # One or both of the above lines turns off security features that weren't working nicely with ajax calls.

  include ExceptionNotifiable

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password


end
