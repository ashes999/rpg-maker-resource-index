#========================================================================
# ** Auto Loader
#    By: ashes999
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
# Automatically loads everything in the "Scripts" subdirectory. With this,
# we can more easily version-control our scripts.
#========================================================================
files = Dir.glob('Scripts/*.rb')
files.each do |f|
    contents = File.read(f)
    eval contents
end
