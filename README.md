# Net Promoter Scores Service

This is a Rails API for a bookstore, it's a basic CRUD that has authors, books, publishers.

## Prerequisites

You will need the following things properly installed on your computer.

* [Ruby](https://www.ruby-lang.org/en/news/2017/03/22/ruby-2-4-1-released/)
* [Ruby On Rails](https://weblog.rubyonrails.org/2019/3/28/Rails-5-1-7-has-been-released/)
* [Redis](https://redis.io/topics/quickstart)
* [Ngrok](https://ngrok.com/download)

## Installation

* `git clone https://github.com/aeltyif/bookstore-api.git`
* `cd bookstore-api`
* `gem install bundler` skip if you have bundler installed
* `bundle install`
* `rails db:migrate`

## Running

* `redis-server` skip if you have redis running
* `bundle exec sidekiq`
* `rails s`
