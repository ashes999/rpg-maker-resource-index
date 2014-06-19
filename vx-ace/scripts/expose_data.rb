#========================================================================
# ** Expose Data
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
# Automatically converts .rvdata2 files into plain text, so you can view
# them and diff them and manage changes to your game more easily.
# Files go in Data/Text.
#========================================================================
def simple_print(obj)
	if obj.is_a?(Hash)
		str = "{\n"
		obj.each do |k, v|		
			str += "\t#{k} => #{v.inspect}\n"
		end
		str += "}"
	elsif obj.is_a?(Array)
		return obj.to_s
	else
		str = "{\n"
			obj.instance_variables.each do |i|
				value = obj.instance_variable_get(i)			
				value = 'nil' if value.nil? || value == ''
				value = simple_print(value) if value.is_a?(Table)
				str += "\t#{i} => #{value.inspect}\n"
			end
		str += "}"
	end
end

files = Dir.glob('Data/*.rvdata2')
Dir.mkdir('Data/Text') if !File.directory?('Data/Text')
files.each do |f|
    binary = File.binread(f)
    object = Marshal.load(binary)
	# Normal: object
	# Classes without to_s: object.inspect	
	#output = object.inspect
	output = simple_print(object)
	File.open(f.sub('Data/', 'Data/Text/').sub('.rvdata2', '-data.txt'), 'w') { |out| out.write(output) }
end

