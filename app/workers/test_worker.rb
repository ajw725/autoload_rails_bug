class TestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Foo::Bar
  end
end