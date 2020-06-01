
eval File.read("colors.rb")

def quiet_sh(*cmd)
  options = (Hash === cmd.last) ? cmd.pop : {}
  options = { verbose: false }.merge(options)

  sh *cmd, options do |ok, status|
    unless ok
      fail "Command failed with status (#{status.exitstatus}):#{BGreen} #{cmd} #{Color_Off}"
    end
  end
end


