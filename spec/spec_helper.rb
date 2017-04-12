$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ethereum'
require 'pry'

HTTP_CLIENT_ADDRESS=ENV['GETH_ADDRESS']||"172.16.135.102"

FIXTURES_PATH=File.expand_path('../fixtures', __FILE__)

puts HTTP_CLIENT_ADDRESS