module Jobbr
  class Engine < ::Rails::Engine

    isolate_namespace Jobbr

    initializer 'jobbr.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Jobbr::ApplicationHelper
      end
    end

  end
end
