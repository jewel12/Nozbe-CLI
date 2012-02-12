# coding:utf-8

module NozbeWrapper

  # Included by Interactor to treat project's actions.
  module Project

    # Show actions of a project of received id's action.
    def show_project_actions( id )
      action = @actions_struct.get_action_from_id( id )
      puts "No sucth id (#{id})" if action.nil?
      output_project( action.project )
      show_actions( get_project_actions( action.project ), 1 )
    end

    def get_project_actions( project )
      actions = project.get_actions( @api_key )
      @actions_struct.set_all( actions )
      return actions
    end

    def show_inbox
      inbox = Nozbe::Project.get_from_name( @api_key, "Inbox" )
      output_project( inbox )
      show_actions( get_project_actions( inbox ), 1 )
    end

    def output_project( project )
      puts "# \e[#{33}m#{project.name}\e[0m"
    end
  end

end
