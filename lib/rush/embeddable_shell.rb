require 'rush/shell'

module Rush
	# This is a class that can be embedded in other applications 
	# rake tasks, utility scripts, etc
	# 
	# Delegates unknown method calls to a Rush::Shell instance
	class EmbeddableShell
		attr_accessor :shell, :first_delegate
		# options 
		# :first_delegate  | default nil
		# :suppress_output | default true
		def initialize(options={})
			options = {:suppress_output => true}.merge(options)
			self.shell = Rush::Shell.new
			shell.suppress_output = options[:suppress_output]
			self.first_delegate = options[:first_delegate]
		end
		
		# evalutes and unkown method call against the rush shell
		def method_missing(sym, *args, &block)
			if first_delegate && first_delegate.respond_to?(sym)
				first_delegate.send(sym, *args, &block)
			else
				shell.execute sym.to_s
				$last_res
			end
		end
		
		# take a whole block and execute it as if it were inside a shell
		def execute_in_shell(&block)
			self.instance_eval(&block)
		end
	end
end