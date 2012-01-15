# coding:utf-8
require 'nozbe'

desc "Get API key"
task :get_key do
  raise "Specified e-mail address or password is required." unless ENV["email"] && ENV["password"]
  user = Nozbe::User.new( ENV["email"], ENV["password"] )
  user.login
  puts user.key
end
