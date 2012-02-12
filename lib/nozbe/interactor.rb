# coding:utf-8
require File.dirname( __FILE__ ) + '/actor'

module NozbeWrapper

  class ActionsStruct
    def initialize
      @actions = {}
      @id = 0
    end

    attr_reader :actions

    def set(action)
      return if @actions[ action.id ]
      @actions[ action.id ] = { id:@id, action:action }
      @id += 1
    end

    def set_all( actions )
      actions.each {|action| set(action) }
    end

    def get_action_from_id( id )
      return @actions.values.find {|a| a[:id] == id}[:action]
    end

    def get_actions( ids )
      return ids.map {|id| get_action_from_id(id) }
    end

    def get_id( action )
      return @actions[ action.id ]
    end
  end

  # Interaction mode
  class Interactor < Actor
    include Project

    def initialize
      super
      @actions_struct = ActionsStruct.new
    end

    def start_interaction
      loop do
        print "> "
        cmd, *values = gets.chomp.split(' ')
        case cmd.to_sym
        when :l
          if values.empty?
            show_actions
          else
            show_project_actions( values.first.to_i )
          end
        when :i
          show_inbox if self.respond_to?(:show_inbox)
        when :d
          set_done( @actions_struct.get_actions(values.map(&:to_i)) )
        when :u
          add_new_action( parse( values ) )
        when :q
          break
        when :o
          p @actions_struct
        else
          puts "Please input specified command."
        end
      end
    end

    # Show received actions. If actions are nil, show next-actions.
    def show_actions( actions=nil, *args )
      actions ||= get_next_actions {|action| @actions_struct.set(action)}
      show( actions, *args )
    end

    private

    def show( actions, *args )
      actions.each {|a| output(a, *args) }
    end

    def output( action, tab_num=0 )
      super( action, tab_num ) { "# (#{@actions_struct.get_id(action)[:id]}) \e[#{33+tab_num}m#{action.name}\e[0m [#{action.project.name}]" }
    end

    def parse( values )
      opts = {}
      opts[:action_name] = values.shift
      # opts[:next] = values.shift == 'n'
      raise NozbeException, "Please input with specified form." if opts.values.index( nil )
      return opts
    end
  end
end
