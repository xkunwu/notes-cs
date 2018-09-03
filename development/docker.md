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