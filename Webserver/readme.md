# How to run the web server

[Sinatra](http://sinatrarb.com) is a DSL for writing web applications. 

## Install sinatra gem 

Try this step first. You might have everything needed.

`gem install sinatra`

If this fails you may need to:

### Install homebrew 

see [Homebrew](https://brew.sh)

### Install ruby if needed 

`brew install ruby` 

Now install the sinatra gem.

## Run Sinatra

Open a new terminal window. 

```
cd <yourpath>/OwlTimer/Webserver
ruby sinatra.rb
```

You can now load a json file of presets at 

`http://localhost:4567/presets`




