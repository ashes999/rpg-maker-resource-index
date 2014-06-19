#========================================================================
# ** Auto Loader
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
# Automatically loads everything in the "Scripts" subdirectory. With this,
# we can more easily version-control our scripts.
#========================================================================
files = Dir.glob('Scripts/*.rb')
files.each do |f|
    contents = File.read(f)
    name = "#{f[0, f.rindex('.rb')]}"
    require name
end