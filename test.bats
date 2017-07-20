#!/usr/bin/env bats

setup() {
  if [ -z ${ver+x} ]; then
    echo 'ver environment variable does not exist'
    exit 1
  fi
  tag=${ver}
}

@test "alpine version is correct" {
  run docker run --rm --entrypoint=/bin/sh graze/bats:$tag -c 'cat /etc/os-release'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[2]}" == "VERSION_ID=3.6."* ]]
}

@test "bats version is correct" {
  run docker run --rm graze/bats:$tag --version
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == "Bats ${ver}"* ]]
  [[ "$output" != *"-dev"* ]]
  [[ "$output" != *"-alpha"* ]]
  [[ "$output" != *"-beta"* ]]
}

@test "entrypoint is bats" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Entrypoint[]'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/bats" ]
}

@test "image has docker installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c '[ -x /usr/bin/docker ]'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "image has make installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c '[ -x /usr/bin/make ]'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "image has curl installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c '[ -x /usr/bin/curl ]'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "image has jq installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c '[ -x /usr/bin/jq ]'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "image has git installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c '[ -x /usr/bin/git ]'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "the image has a MIT license" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.license'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "MIT" ]
}

@test "the image has a maintainer" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.maintainer'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "developers@graze.com" ]
}

@test "the image uses label-schema.org" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.schema-version\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "1.0" ]
}

@test "the image has a vcs-url label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vcs-url\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "https://github.com/graze/docker-bats" ]
}

@test "the image has a vcs-ref label set to the current head commit in github" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vcs-ref\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = `git rev-parse --short HEAD` ]
}

@test "the image has a build-date label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.build-date\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" != "null" ]
}

@test "the image has a vendor label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vendor\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "graze" ]
}

@test "the image has a name label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.name\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "bats" ]
}

@test "the image has a version label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.version\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "$tag" ]
}

@test "the image has a docker.cmd label" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Labels.\"org.label-schema.docker.cmd\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \$(pwd):/app graze/bats" ]
}
