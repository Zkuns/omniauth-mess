require 'omniauth-oauth2'
dires = Dir[File.join(File.dirname(__FILE__), '*')].select{ |file| File.directory?(file) }
dires.each{ |dir| Dir[File.join(dir, '*.rb')].each {|file| require file } }
