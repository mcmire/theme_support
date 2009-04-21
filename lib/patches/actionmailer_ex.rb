module ThemeSupport
  module ActionMailer
    def self.included(base)
      base.class_eval do
        attr_reader :current_theme
      end
    end
   
    def initialize(method_name=nil, *parameters)
      if parameters[-1].is_a? Hash and (parameters[-1].include? :theme)
        @current_theme = parameters[-1][:theme]
        parameters[-1].delete :theme
        parameters[-1][:current_theme] = @current_theme
      end
      super(method_name, *parameters)
    end
  
    def render(opts)
      body = opts[:body]
      body[:current_theme] = @current_theme
      super(opts)
    end
   
  end
end

ActionMailer::Base.class_eval { include ThemeSupport::ActionMailer }