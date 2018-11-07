module Jobbr
  class ApplicationController < ActionController::Base

    before_action :set_locale

    protected

    def set_locale
      I18n.locale = :en
    end

  end
end
