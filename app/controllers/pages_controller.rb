class PagesController < ApplicationController
  def home
  end

  def cause_bug
    thing = Foo::Bar.new
    thing.say_hello
    TestWorker.perform_async
    respond_to do |format|
      format.json { render status: 200, json: { success: true } }
    end
  end
end