class StaticPagesController < ApplicationController

  skip_before_action :require_signed_in!, only: [:about, :contact]

  def about
  end

  def contact
  end
end
