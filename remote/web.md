---
---
### Mirror website and change links to local

```sh
wget --mirror -p --convert-links -P local_name remote_name
```

### Silent download

```sh
wget -bqc target_url
where:
-b : Go to background immediately after startup. If no output file is specified via the -o, output is redirected to wget-log.
-q : Turn off Wget's output (saves some disk space)
-c : Resume broken download i.e. continue getting a partially-downloaded file. This is useful when you want to finish up a download started by a previous instance of Wget, or by another program.
```

### Follow the redirect URL

```sh
curl -L remote_name > local_name
```

### Campus Network automatic authentication

1. Web Developer Tools > Network > Settings: check `Persist Logs`
2. Login once, read the log and search:
   1. POST: `InterFace.do?method=login`
   2. Copy > Copy as cURL, which becomes `curl` command and contains login info in the Cookie.
3. Paste into the console and execute it: the server will return a success message.
   1. Shorter command: just feeding the `--data-raw` section into `curl 'http://172.30.1.1/eportal/InterFace.do?method=login' --data-raw` will also work.
