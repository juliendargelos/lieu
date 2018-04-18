# Lilu

[lilu-gobelins.herokuapp.com](https://lilu-gobelins.herokuapp.com)

## Install

### Clone the repository

```shell
git clone git@github.com:juliendargelos/lilu.git
cd lilu
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.5.0`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 2.5.0
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler):

```shell
bundle
```

### Set environment variables

Using [Figaro](https://github.com/laserlemon/figaro):

See [config/application.yml.sample](https://github.com/juliendargelos/lilu/blob/master/config/application.yml.sample) and contact the developer: [contact@juliendargelos.com](mailto:contact@juliendargelos.com) (sensitive data).

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

### Add heroku remotes

Using [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```shell
heroku git:remote -a lilu
heroku git:remote --remote heroku-staging -a lilu-staging
```

## Serve

```shell
rails s
```

## Deploy

Push to Heroku production remote:

```shell
git push heroku
```
