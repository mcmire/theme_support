# Extend the Base ActionController to support themes
module ThemeSupport
  module ActionControllerEx

    def self.included(base)
      base.class_eval do
        attr_writer :current_theme
        attr_writer :force_liquid_template
        extend ClassMethods
      end
    end
   
    module ClassMethods
      # Use this in your controller just like the <tt>layout</tt> macro.
      # Example:
      #
      #  theme 'theme_name'
      #
      # -or-
      #
      #  theme :get_theme
      #
      #  def get_theme
      #    'theme_name'
      #  end
      def theme(theme_name, conditions = {})
        add_theme_conditions(conditions)
        write_inheritable_attribute "theme", theme_name
      end

      # Set <tt>force_liquid</tt> to true in your controlelr to only allow 
      # Liquid template in themes.
      # Example:
      #
      #  force_liquid true
      def force_liquid(force_liquid_value, conditions = {})
        # TODO: Allow conditions... (?)
        write_inheritable_attribute "force_liquid", force_liquid_value
      end
      
      def theme_conditions #:nodoc:
        @theme_conditions ||= read_inheritable_attribute(:theme_conditions)
      end
      
    private
      def add_theme_conditions(conditions)
        write_inheritable_hash(:theme_conditions, normalize_conditions(conditions))
      end
    end

    # Retrieves the current set theme
    def current_theme(passed_theme=nil)
      theme = passed_theme || self.class.read_inheritable_attribute("theme") if action_has_theme?
   
      @active_theme = case theme
        when Symbol then send(theme)
        when Proc   then theme.call(self)
        else             theme
      end
    end
 
    # Retrieves the force liquid flag
    def force_liquid_template(passed_value=nil)
      force_liquid = passed_value || self.class.read_inheritable_attribute("force_liquid")

      @force_liquid_template = case force_liquid
        when Symbol then send(force_liquid)
        when Proc   then force_liquid.call(self)
        when String then force_liquid == 'true'
        when TrueClass then force_liquid
        when FalseClass then force_liquid
        when Fixnum then force_liquid == 1
      end
    end
    
  private
    def action_has_theme?
      if conditions = self.class.theme_conditions
        case
          when only   = conditions[:only]   then only.include?(action_name)
          when except = conditions[:except] then !except.include?(action_name)
          else true
        end
      else
        true
      end
    end

  end
end

ActionController::Base.class_eval { include ThemeSupport::ActionControllerEx }