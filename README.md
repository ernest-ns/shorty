Welcome to YAUS (Yet Another URL Shortener)
-----------------------------------------------------------------

[![Code Climate](https://codeclimate.com/github/codeclimate/codeclimate/badges/gpa.svg)](https://codeclimate.com/github/codeclimate/codeclimate)


## How to Setup
> **Note:**

>The setup instructions are for a fresh install of Ubuntu 14.04

### Install required packages
`sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev  libffi-dev libgdbm-dev libncurses5-dev automake libtool bison postgresql postgresql-contrib libpq-dev`

### Install rvm

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby-2.3.0
rvm use ruby-2.3.0 --default
```

### Install bundler

`gem install bundler`

### Clone Code and install gems

```
git clone https://github.com/ernest-ns/shorty.git && cd shorty/
bundle install
```


### Setup Postgress

```
sudo -u postgres createuser -s vagrant
sudo -u postgres psql -c "ALTER USER vagrant PASSWORD 'password';"
```


### Run the migration

```
rake ar:create
rake ar:migrate
```

## Tests

Run this command in the home folder to run the tests.

`rspec spec`