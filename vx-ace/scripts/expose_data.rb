#========================================================================
# ** Expose Data
#    By: ashes999
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
# Automatically converts .rvdata2 files into plain text, so you can view
# them and diff them and manage changes to your game more easily.
# Files go in Data/Text.
#========================================================================
def simple_print(obj)
	if obj.is_a?(Hash)
		str = "{\n\r"
		obj.each do |k, v|		
			str += "\t#{k} => #{v.inspect}\n\r"
		end
		str += "}"
	elsif obj.is_a?(Array)
		return obj.to_s
	else
		str = "{\n\r"
			obj.instance_variables.each do |i|
				value = obj.instance_variable_get(i)			
				value = 'nil' if value.nil? || value == ''
				value = simple_print(value) if value.is_a?(Table)
				str += "\t#{i} => #{value.inspect}\n\r"
			end
		str += "}"
	end
end

# Remove memory addresses so we don't get unnecessary "noise" in diffs
def clean(string)
	return string.gsub(/0x[0-9a-f]{7}/, '0xXXXXXXX')
end

files = Dir.glob('Data/*.rvdata2')
Dir.mkdir('Data/Text') if !File.directory?('Data/Text')
files.each do |f|
    binary = File.binread(f)
    object = Marshal.load(binary)
	# Normal: object
	# Classes without to_s: object.inspect	
	#output = object.inspect
	output = clean(simple_print(object))
	File.open(f.sub('Data/', 'Data/Text/').sub('.rvdata2', '-data.txt'), 'w') { |out| out.write(output) }
end

