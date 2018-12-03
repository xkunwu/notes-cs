---
---
## Test tools
    - Doctest: searches for pieces of text that look like interactive Python sessions in docstrings.
    - py.test: is a no-boilerplate alternative to Python’s standard unittest module.
    - tox: for automating test environment management and testing against multiple interpreter configurations.
    - mock:allows you to replace parts of your system under test with mock objects and make assertions about how they have been used.

## Depending on where your code repository is hosted I would make the following choices:
[from StackOverflow answer](https://stackoverflow.com/a/32422909)

    - in-house --> Jenkins or gitlab-ci
    - Github.com --> Travis-CI

## Jenkins starup
```
docker run \
  --name jenkins_host \
  --rm \
  -u root \
  -e JENKINS_OPTS="--httpPort=8808" \
  -p 8808:8808 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME"/projects:/home/projects \
  jenkinsci/blueocean
```
#### Access container using bash:
```
docker exec -it jenkins_host bash
```
#### Running jenkins jobs via command line
- Build Triggers: Trigger builds remotely, Poll SCM
- Show API token
- issue command
```
curl -X POST http://USER@palau:8808/job/JOBNAME/build
```
- Obtain crumb (optional, if required)
```
wget -q --auth-no-challenge --user xwu --password ??? --output-document - 'http://palau:8808/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
curl -X POST http://USER@palau:8808/job/JOBNAME/build -H "CRUMB"
```

## GitLab startup
```
docker run -d \
  --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:alpine
```
gitlab/gitlab-runner:latest
