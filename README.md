# ruby-version-scanner

Check https://ruby-lang.org for new releases of Ruby (compared against provided knownversions.txt file), notify subscribers about new release and update knownversions.txt file. 

## Run locally 


```
ruby versions.rb knownversions.txt
```

## Run via container

```
docker build -t ruby-version-scanner .
docker run -it -v /mydir/data/:/data:rw ruby-version-scanner
```

## Run prebuilt container image 

```
docker pull ghcr.io/doerfli/ruby-version-scanner:main
docker run -v /mydir/data:/data:rw ghcr.io/doerfli/ruby-version-scanner:main
```

