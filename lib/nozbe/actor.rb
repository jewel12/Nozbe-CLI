# coding:utf-8

module NozbeWrapper

  # Treat action list.
  class Actor

    # An authentication are passed using api-key.
    def initialize
      @user = Nozbe::User.new(nil,nil)
      @api_key = NozbeWrapper::SETTING[:api_key]
    end

    def show_actions
      show( get_next_actions )
    end

    private
    def show( actions )
      actions.each {|a| output(a) }
    end

    def output( action, tab_num=0 )
      tab_num.times{ print "\t" }

      if block_given?
        out_str = yield
      else
        out_str = "# \e[33m#{action.name}\e[0m [#{action.project.name}]"
      end

      print out_str
      puts action.done ? " \e[35mdone!\e[0m" : ''
    end

    def get_next_actions
      actions = Nozbe::Action.list_next( @api_key )

      if block_given?
        actions.each do |action|
            yield( action )
        end
      end

      return actions
    end

    # Set done-flag.
    def set_done( actions )
      actions = [actions] unless actions.respond_to?(:[])
      actions.each do |action|
        action.done!( @api_key )
      end
    end

    # Add new action to Inbox
    def add_new_action( opts )
      new_action = Nozbe::Action.new
      new_action.name = opts[:action_name]
      new_action.next = opts[:next]
      new_action.project = Nozbe::Project.new
      new_action.project.name = "Inbox"
      new_action.context = Nozbe::Context.new
      new_action.save!( @api_key )
    end
  end
end
