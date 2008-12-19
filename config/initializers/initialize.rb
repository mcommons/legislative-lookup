Mime::Type.register "application/vnd.google-earth.kml+xml", :kml
Mime::Type.register "application/xml.georss", :georss

ExceptionNotifier.exception_recipients = %w(alarm@mcommons.com)
ExceptionNotifier.sender_address = %("Application Error" <notifier@mcommons.com>)