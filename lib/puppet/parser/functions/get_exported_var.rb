#
# get_exportedvar.rb
#
# This define retrieves the values of the specified exported var name
# TODO: Make this thing work :-)
#
#require 'logger'

module Puppet::Parser::Functions
  newfunction(:get_exported_var, :type => :rvalue, :doc => <<-EOS

    This returns a comma separated array of values
    Usage: get_exportedvar ( "tag ", "name ", "default" )

    EOS
  ) do |args|

    raise(Puppet::ParseError, "get_exported_var(): Wrong number of args " +
      "given (#{args.size} for 3)") if args.size < 3

    dir = "/var/lib/puppet/exported_var"
    tag = args[0]
    name = args[1]
    dvalue = args[2]

#    log = Logger.new('/tmp/log.txt')
#    log.debug "Log file created"
#    log.debug "(#{args[0]}, #{args[1]}, #{args[2]}, #{args[3]})"
#    log.debug "(#{tag}, #{name}, #{dvalue}, #{dir})"

    if File.directory?("#{dir}")
      Dir.chdir("#{dir}") 
      values = Dir.glob('*').grep(/^#{tag}/).grep(/#{name}$/) do |f| 
        File.read(f).tr("\n","")
      end
      #log.debug "(Values.n = #{values.nil?})"
      if values.empty?
        dvalue
      else
        values.to_a
        # values.join(',')
      end
    else
      dvalue
    end
  end
end

# vim: set ts=2 sw=2 et :

