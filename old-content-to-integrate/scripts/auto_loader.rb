#========================================================================
# ** Auto Loader
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
# Automatically loads everything in the "Scripts" subdirectory. With this,
# we can more easily version-control our scripts.
#========================================================================

# Which scripts should you load first?
require_first = []

####

require_first.each do |r|
  require "Scripts/#{r}"
end

files = Dir.glob('Scripts/*.rb')
files.each do |f|
    contents = File.read(f)
    name = "#{f[0, f.rindex('.rb')]}"
    require name
end