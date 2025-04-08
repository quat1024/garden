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
* foreign key should be "primary key" or "candidate key"

associations can have like, "on delete" actions

```ruby
class Student < ApplicationRecord
  student belongs_to :team
end

class Team < ApplicationRecord
  team has_many :students
end
```

# alright whats in this next class

```ruby
class User < ApplicationRecord
(..something...) password validates: has_secure_password
```

can add the `bcrypt` gem like `gem "bcrypt", "~> 3.1.7"`

`rails g migration add_pasword_to_users password_digest:string`

there was a little script with `faker` to add fake users for testing

## another class whatever

`rails generate migration add_password_to_users password_digest:string`

`rails generate controller user index new show edit`

typical crud apis:

* GET `/users` - action "index" - show everyone
* GET `/users/1` - action "show" - show one user
* GET `/users/new` - action "new" - form to make a new user
* POST `/users` - action "create" - endpoint to make a new user
* GET `/users/1/edit` - action "edit" - form to edit a user
* PATCH `/users/1` - action "update" - endpoint to edit a user
* DELETE `/users/1` - action "delete" - delete a user

# these notes are a mess

let's start over

## bigger picture

rails is a model-view-controller framework

* the model: the bit that talks to the database. this is handled with an ORM called Active Record
* the view: the bit that renders html. this is done with erb templates (it's called "active view")
* the controller: vaguely-defined glue beteween everything else.
* there's also a routing table which decides which controller to use for a given request.

probably the most important thing: methods in the controller configure the view basically. when you set instance-variables (`@var`) you can read `@var` from the erb template

basically dhh likes the word Active like how mr melon musk likes the letter x

## routing

https://guides.rubyonrails.org/routing.html

the most general syntax:

```ruby
get "/users/:id", controller: "users", action: :show
```

get -> the HTTP verb, there are ruby methods for each verb.

controller -> the controller to pass this to. this corresponds to some file in the controllers directory. (if there's more than one word, you need to snake_case it)

show -> the method to call inside the controller. this is a symbol

the routing file is interpreted top-to-bottom and the first matching rule will work

### "to" shorthand

you can glue `controller` to `action` by using `to` instead

```ruby
get "/users/:id", to: `users#show`
```

### "resources" shorthand

this set of eight routes 

```ruby
get    "/photos"         , to: "photos#index"   # list photos
get    "/photos/new"     , to: "photos#new"     # form for making photo
post   "/photos"         , to: "photos#create"  # endpoint for making photo
get    "/photos/:id"     , to: "photos#show"    # show photo
get    "/photos/:id/edit", to: "photos#edit"    # form for editing photo
patch  "/photos/:id"     , to: "photos#update"  # endpoint for editing photo
put    "/photos/:id"     , to: "photos#update"  # endpoint for editing photo (2)
delete "/photos/:id"     , to: "photos#destroy" # delete photo
```

can be abbreviated simply as 

```ruby
resources :photos
```

if you only want a few of these, use `only: `. for example

```ruby
resources :photos, only: [:index, :show, :edit, :update]
```

and if you want to move it, use `path: `.

```ruby
resources :things, path: "/some/path/things`
```

### "resource" shorthand

afaik this is basically `resources :thing` but doesn't include `:index` and with different rules about pluralization

### path helpers

every route comes with two "route helpers", global variables that contain paths to the route

for example

```ruby
get "/foo", to: "foo#index"
```

defines

* `foo_path`, containing `/users`
* `foo_url`, containing `https://example.com/users`

also, somehow this works (this is from the example)

```ruby
get "/users/:id", to: "users#show", as: "user"

#...

<%= link_to 'User Record', user_path(@user) %>
```

(`as` gives an explicit name for the route helpers)

so this time `user_path` and `user_url` are functions that take a `User` object and presumably plucks out its id. `user_path` is like a way of saying "url to this user". imagine you're emitting, like, a comments section and want to link to each user: yeah.

if you want to make your own url helpers, use `direct :helper_name do` and return a `url_for`rable thing in there (string, hash, array, activemodel instance or class)

from the guide.

```ruby
direct :homepage do
  "https://rubyonrails.org"
end

# >> homepage_url
# => "https://rubyonrails.org"
```

### listing routes

the `rails routes` command will parse your routes table and list them all

### namespaces

```
namespace :admin do
  resources :articles
```

this puts the `articles` routes under `/admin`, i.e. `/admin/articles/new`

the controller is also namespaced. it will look for `Admin::ArticlesController`

* to namespace only the controller, use `scope module: "admin"`. stuff inside the block is still routed at the top-level but it will look for `Admin::ArticlesController`
* to scope only the routes, use `scope "/admin"`. this will nest all the routes under `/admin`, but the controller is still `ArticlesController` without the module

## nested routes

now we're at the good stuff

if you have two models

```ruby
class Post < ApplicationRecord
  has_many :comments
end

class Comment < ApplicationRecord
  belongs_to :post
end
```

then this makes sense

```ruby
resources :posts do
  resources :comments
end
```

this creates routes for posts and also creates routes for comments. for example `get /posts/:post_id/comments/:comment_id/edit`. the url helpers take a `Post` and a `Comment` record

you can nest routes as deeply as you like but it does kinda become a mess. the right amount of nesting depends on what you want the urls to look like.

## optional segments

`get "photos(/:id)", to: "photos#display"` routes both `/photos/:id` and `/photos` to `photos#display`. this controller should handle the case where the parameter is not present

## wildcard segments

`get "photos/*id"`, the id can contain slashes.

## routing-table level redirections

`get "/stories", to: redirect("/articles")`

this serves a 301 by default. you can serve a 302 like this

`get "/stories", to: redirect("/articles", status: 302)`

## "Rack applications"

"Rack" is a ruby standard for web server middleware. a "rack application" is anything with a function `call` that returns `[status, headers, body]`.

you can specify a rack application in `to` instead of a string. The guide mentions that when rails sees a string in `to` (say `posts#index`), it expands that to `PostsController.action(:index)` and that is a rack application. probably somewhere in rails machinery

## `root`

```ruby
root to: "posts#index"
root "posts#index" # same thing
```