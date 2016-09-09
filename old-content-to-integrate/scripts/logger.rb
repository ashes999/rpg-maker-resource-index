#========================================================================
# ** Logger
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 1.0
#------------------------------------------------------------------------
# * Description:
# Allows you to log messages at a given level (default is :info).
# Levels are: :info, :debug. 
#========================================================================

LOGGING_LEVEL = :info

#### end of parameters ###

LEVELS = { :info => 1, :debug => 2 }

class Logger

	@@first_message = true

	def self.log(message, level = LOGGING_LEVEL)
		return if level > LOGGING_LEVEL
		
		mode = @@first_message ? 'w' : 'a'
		
		File.open('log.txt', mode) { |f|
			f.write("#{message}\n")
		}
		
		@@first_message = false
	end
	
	def self.info(message)
		Logger.log(message, :info)
	end
	
	def self.debug(message)
		Logger.log(message, :debug)
	end		
end

