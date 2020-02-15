# Reproducing a Rails autoloading concurrency bug

## Github issue
[LoadError when multiple threads try to load the same namespaced class](https://github.com/rails/rails/issues/33209)

## Setting up the application

1. clone the repository
1. `bundle install`

## Steps to reproduce

### From the Rails console

(this example adapted from [Dimitrios Lisenko](https://github.com/DimitriosLisenko))

1. start up a rails console (`bundle exec rails c`)
1. run `Foo::Bar`, which should be successful
1. start up a new rails console
1. run `2.times { Thread.new { Rails.application.executor { Foo::Bar } } }`. this does not fail every time,
    but it should occasionally fail with either an ArgumentError ("A copy of Foo has been removed from the
    module tree but is still active!") or a LoadError ("Unable to autoload constant Foo::Bar,
    expected [...]/app/models/foo/bar.rb to define it").
    
### In the Rails server

1. boot up the application (`bundle exec rails s`)
1. load the home page (navigate to `localhost:3000`)
1. again, this doesn't work 100% of the time, but it should occasionally reproduce the error (as long as you
restart the server before each attempt). once again, the specific error can change between occurrences.

### In Sidekiq

In my testing, this is the most reliable reproduction.

1. start redis
1. boot up the application (`bundle exec rails s`) but do **not** start sidekiq
1. load the home page (navigate to `localhost:3000`)
1. start sidekiq (`bundle exec sidekiq`)
1. when sidekiq starts, it will immediately kick off two identical workers. one will succeed, but the other will
    fail with one of the errors described above.

