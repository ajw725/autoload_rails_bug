class PagesController < ApplicationController
  def home
  end

  def cause_bug
    thing = Foo::Bar.new
    thing.say_hello
    respond_to do |format|
      format.json { render status: 200, json: {success: true} }
      format.js { render status: 200, json: {success: true} }
    end
  end
end