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
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c 'docker --version'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Docker version"* ]]
}

@test "image has make installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c 'make --version'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "GNU Make"* ]]
}

@test "image has curl installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c 'curl --version'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "curl"* ]]
}

@test "image has jq installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c 'jq --version'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "jq-"* ]]
}

@test "image has git installed" {
  run docker run --rm --entrypoint="/bin/sh" graze/bats:$tag -c 'git --version'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "git version"* ]]
}
