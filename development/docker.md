### quick cleanups
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

### Returns how many non-0 exit codes were returned.
```
docker-compose ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v 0 | wc -l | tr -d ' '
```

### sent to background, then reattach
```
C+p C+q
docker attach
```
