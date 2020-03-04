# README

[企画書はこちら](https://docs.google.com/presentation/d/1jGc0OcA5aQu3cRi78JW1BjPTYjoJxO1T6YuLFuPALRM/edit?usp=drive_web&ouid=113388058663145988908)

## 環境
- ubuntu18.04LTS
```
$ ruby -v
ruby 2.5.1p57
$ gem -v
2.7.6
$ rails -v
Rails 5.1.7
$ git --version
git version 2.17.1
```

## for Docker
```
$ docker-compose up --build -d
$ docker exec -it web 
```

### deploy
```shell script
$ docker-compose -f docker-compose.yml -f dev.docker-compose.yml up (--build)
$ docker-compose -f docker-compose.yml -f pro.docker-compose.yml up (--build)
```

## only dev
validate: KYODAI_EMAIL


## Settings
### deploy
```bash
$ bundle install --without development
$ bundle exec rake assets:precompile RAILS_ENV=production
$ rails db:migrate RAILS_ENV=production
$ npm install
$ bundle exec whenever --update-crontab
# not recommend
$ rails s -e production

```

### Util
```bash
$ rails c -e production

$ RAILS_ENV=production rake db:migrate VERSION=0
```

### StopServer
```bash
# kill puma process
$ ps aux | grep puma
$ bundle exec whenever --clear-crontab
```
