module Jobbr
  class ApplicationController < ActionController::Base

    layout :layout_by_resource

    def layout_by_resource
      request.headers['X-PJAX'] ? false : 'jobbr/application'
    end

  end
end
