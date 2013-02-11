module Jobbr
  class ApplicationController < ActionController::Base

    layout :layout_by_resource

    before_filter :set_locale

    protected

    def set_locale
      I18n.locale = :en
    end

    def layout_by_resource
      request.headers['X-PJAX'] ? false : 'jobbr/application'
    end

  end
end
