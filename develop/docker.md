---
---
{% raw %}
### Change owner recursively
```
id
chown -R 1000:1000 some_path
```

### Copy file from the container
```
docker cp CONTAINER:SRC_PATH DEST_PATH
```

### Quick cleanups
- Kill all containers that are currently running:
```
docker kill $(docker ps -q)
```
- Delete all containers that are not currently running:
```
docker rm $(docker ps -a -q)
```
- Clean up dangling images:
```
docker rmi $(docker images -f "dangling=true" -q)
```
- Better way of cleaning images (require API 1.25):
```
docker image prune --force
```

## Commit with changes
```
docker commit --change "ENV PATH=/opt/conda/bin:$PATH" 73a12e028083 tensorflow-1.12
```

### Sent to background, then reattach
```
C+p C+q
docker attach container
```

### Running container can be connected from another shell - a very good way of checking problem, e.g., using 'ps aux'
```
docker exec -ti container bash
```

## Restart an existing container after it exited (changes are still there)
```
docker start  `docker ps -q -l` # restart it in the background
docker attach `docker ps -q -l` # reattach the terminal & stdin
```

### Returns how many non-0 exit codes were returned.
```
docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '
```
{% endraw %}
