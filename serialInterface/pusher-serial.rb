require 'rubygems'
require 'pusher-client'
require 'JSON'
require 'serialport'

# Parse command line
usbmodem = ARGV[0]
secret = ARGV[1]
appkey = ARGV[2]

# Open a serial connection
#sp = SerialPort.new(usbmodem, 1200)
cv = false;

# Define emily parser for control data
# FORMAT: {'key':'w'}
def parseControl(data)
	parsedData = JSON.parse(data)
	control = parsedData['control']
	#sp.write control
	puts control
end

# Check if Serial interface provided
if ARGV.length == 0
	abort("Usage: ruby pusher-serial.rb serialinterface")
end

# Setup Pusher Client asynchronously
PusherClient.logger = Logger.new(STDOUT)
options = {:encrypted => true, :secret => secret} 
socket = PusherClient::Socket.new(appkey, options)

# Subscribe to emily channel
socket.subscribe('private-emily')

# Bind to a channel event 
socket['emily'].bind('client-control') do |data|
	parseControl data
end

# Connect to socket
socket.connect 