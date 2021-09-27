# ruby-version-scanner

Check https://ruby-lang.org for new releases of Ruby (compared against provided knownversions.txt file) and notify subscribers about new release via email. 
Email notification requires a [mailgun account](https://www.mailgun.com/) for sending. 

## Run locally 


```
ruby versions.rb knownversions.txt
```

## Run via container

```
docker build -t ruby-version-scanner .
docker run -it -v /mydir/data/:/data:rw -e MAILGUN_API_KEY=<mailgun-api-key> -e MAILGUN_URL=<MAILGUN_URL> -e MAILGUN_SERVER=<MAILGUN_DOMAIN> -e RECIPIENTS=<RECIPIENTS> ruby-version-scanner

docker run -it -v /mydir/data/:/data:rw -e MAILGUN_API_KEY=abcde -e MAILGUN_URL=<https://api.mailgun.net/v3/yourdomain.com/messages -e MAILGUN_SERVER=yourdomain.com -e RECIPIENTS=me@somewhere.org ruby-version-scanner
```

## Run prebuilt container image 

```
docker pull ghcr.io/doerfli/ruby-version-scanner:main
docker run -v /mydir/data:/data:rw -e MAILGUN_API_KEY=<mailgun-api-key> -e MAILGUN_URL=<MAILGUN_URL> -e MAILGUN_SERVER=<MAILGUN_DOMAIN> -e RECIPIENTS=<RECIPIENTS> ghcr.io/doerfli/ruby-version-scanner:main
```

