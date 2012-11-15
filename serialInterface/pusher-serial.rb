require 'rubygems'
require 'pusher-client'
require 'JSON'
require 'serialport'

# Parse command line
usbmodem = ARGV[0]
secret = ARGV[1]
appkey = ARGV[2]

# Open a serial connection
sp = SerialPort.new(usbmodem, 1200)
cv = false;

# Define emily parser for control data
# FORMAT: {'key':'w'}
def parseControl(data, sp)
	parsedData = JSON.parse(data)
	control = parsedData['key']
    if control.upcase == 'A'
        puts 'D'
    elsif control.upcase == 'D'
        puts 'A'
    else
	    puts control
    end
	sp.write control
end

# Check if Serial interface provided
if ARGV.length == 0
	abort("Usage: ruby pusher-serial.rb serialinterface")
end

# Setup Pusher Client asynchronously
PusherClient.logger = Logger.new(STDOUT)
socket = PusherClient::Socket.new(appkey, {:secret => secret} )

# Subscribe to emily channel
socket.subscribe('private-emily')

# Bind to a channel event 
socket['private-emily'].bind('client-control') do |data|
	puts data
	parseControl(data,sp)
end

# Connect to socket
socket.connect 
