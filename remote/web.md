---
---
### Mirror website and change links to local
```
wget --mirror -p --convert-links -P local_name remote_name
```

### Silent download
```
wget -bqc target_url
where:
-b : Go to background immediately after startup. If no output file is specified via the -o, output is redirected to wget-log.
-q : Turn off Wget's output (saves some disk space)
-c : Resume broken download i.e. continue getting a partially-downloaded file. This is useful when you want to finish up a download started by a previous instance of Wget, or by another program.
```

### Follow the redirect URL
```
curl -L remote_name > local_name
```
