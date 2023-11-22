# BATS (bash automated testing system)

[![Build Status](https://img.shields.io/travis/graze/docker-bats/master.svg)](https://travis-ci.org/graze/docker-bats)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/bats.svg)](https://hub.docker.com/r/graze/bats/)
[![Image Size](https://images.microbadger.com/badges/image/graze/bats.svg)](https://microbadger.com/images/graze/bats)

This is a docker image containing [bats-core](https://github.com/bats-core/bats-core) and a few other useful bits: [jq](https://stedolan.github.io/jq/), make, curl, docker, git

## Usage

```bash
docker run --rm -v $(pwd):/app graze/bats /app/tests
```

## Usage with docker

To be able to run docker commands within this container you need to mount the docker sock:

```bash
docker run --rm \
    -v $(pwd):/app \
    -v /var/run/docker.sock:/var/run/docker.sock \
    graze/bats /app/tests
```

```sh
@test "entrypoint is bats" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Entrypoint[]'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/bats" ]
}
```
