# Rails

We're talking a bit about *Ruby on Rails* in the final part of this class. This framework promises the world, let's see what happens.

just following along with the lecture...

* `rails new someproject` -> creates a new project in `./someproject`
* `rails serve` (or simply `rails s`) -> start a live server

## routing basics

Routing is defined in `./config/routes.rb`. we went to `app/controllers/application_controller.rb` and changed it to

```ruby
class ApplicationController < ActionController::Base
  def hello
    render html: 'hello world'
  end
end
```

then in the routes

```ruby
get "application/hello"
```

this means:

* `<host>/application/hello` is mapped as a GET request
* the controller is `application`, rails automatically looks in `app/controllers/<name>_controller` for it
* the (some other terminology, maybe just the "path") is `hello`, which means we call the `hello` function in that controller
* the function calls `render` and "hello world" gets output to the browser

### other routes

```ruby
get "foo", to: "application#hello"
```

routes `<host>/foo` to the same place

```ruby
root to: "application#main"
```

routes `<host>/` to the same place

## g

`rails g controller staticPage home help`;  short for `rails generate`

prints

```
      create  app/controllers/static_page_controller.rb
       route  get "static_page/home"
              get "static_page/help"
      invoke  erb
      create    app/views/static_page
      create    app/views/static_page/home.html.erb
      create    app/views/static_page/help.html.erb
      invoke  test_unit
      create    test/controllers/static_page_controller_test.rb
      invoke  helper
      create    app/helpers/static_page_helper.rb
      invoke    test_unit
```

we codegen all these files

* a controller called `static_page`
* two routes, `get "static_page/home"` and `get "static_page/help"`, are added to the routing table in routes.rb
* two views, `app/views/static_page/home.html.erb` and same for `about.html.erb`
* some tests, and a "helper" idk what that's about

interesting is that the controller looks like this:

```
class StaticPageController < ApplicationController
  def home
  end

  def help
  end
end
```

but visiting `<host>/static_page/about` does indeed render the view in `app/views/static_page/home.html.erb`

## main template

`views/layouts/application.html.erb` contains the html framework, with a `yield` for the slot accepting the page-specific template

this corresponds to `ApplicationController`? yes. i don't know the exact mechanism by which these are plugged in together - maybe it's because `StaticPageController` extends `ApplicationController`?

yes indeed - changing `StaticPageController` to extend `ActionController::Base` causes no outer template to be rendered

## slotting things into the outer template

running this typea thing in the inner template `<% provide(:title, "lalskhdjashkasd") %>` causes `:title` to hold the value `lalskhdjashkasd`

TODO: surely there's also a way to do this from the controller? calling the same function from `controllers/static_page_controller.rb` doesn't do anything.

## link_to

`<%= link_to "link text", "url" %>` can be used from a template. for example you could build a nav by slapping a few of these in `controllers/application.html.erb`.

the second parameter can be a *relative* url fragment, or some magical variable called `asd_path` where `asd` is ...  something in the routing table? like if you have `get "home", "something#home"` then the variable `home_path` is defined

this seems kind of silly, because the variable `home_path` just contains the value "/home"

## partials

partials can be put in `app/views/layouts/`, they start with an underscore. so maybe `layouts/header.html.erb`

invoke the partial with `<%= render "layouts/header" %>`. no underscore! dont forget the `<%=` since you do want to output it right.

## data

`rails db:create` makes a database file, it's stored in `storage/xxxx.sqlite3`

you don't describe the shape of the database *directly*, but you describe how to change the existing database into the one you want. this allows you to go forward and back in time.

`rails generate migration` helps you make a migration file. there are other arguments to append which set the name and prefill some bits of the migration (todo look those up). the current datetime is prepended to the file, so that `rails db:migrate` can run the migrations in order.

theyve got activerecord ORM stuff so you dont write too much sql directly. thats the idea anyway.

# databases

i took a databases class before but yeah the basics

* you have some objects
* there's a primary key to identiy each object (afaik rails likes to use arbitrary object ids)
* relationships between objects are "associations" in rails. which are foreign key constraints
  * 1:n and n:1 just slap a field on one of the tables
  * n:m needs a secondary table to hold the associations

associations can have like, "on delete" actions

```ruby
class Student < ApplicationRecord
  student belongs_to :team
end

class Team < ApplicationRecord
  team has_many :students
end
```